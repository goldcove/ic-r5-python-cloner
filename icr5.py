#!/usr/bin/env python3
"""Read and write Icom IC-R5 clone images over a serial interface."""

from __future__ import annotations

import argparse
import sys
import time
from pathlib import Path
from typing import Iterator

from icr5_errors import ICR5Error

try:
    import serial
    from serial.tools import list_ports
except ImportError:  # pragma: no cover - exercised by users before installation
    serial = None
    list_ports = None


RADIO_ADDRESS = 0xEE
PC_ADDRESS = 0xEF
PREAMBLE = b"\xFE\xFE"
TERMINATOR = 0xFD
MESSAGE_COUNT = 896
CHUNK_SIZE = 32
IMAGE_SIZE = MESSAGE_COUNT * CHUNK_SIZE


def checksum(data: bytes) -> int:
    """Return the IC-R5 two's-complement modulo-256 checksum."""
    return (-sum(data)) & 0xFF


def unpack_hex(data: bytes) -> bytes:
    """Convert binary bytes to the radio's uppercase ASCII-hex representation."""
    return data.hex().upper().encode("ascii")


def pack_hex(data: bytes) -> bytes:
    """Convert the radio's ASCII-hex representation to binary bytes."""
    try:
        return bytes.fromhex(data.decode("ascii"))
    except (UnicodeDecodeError, ValueError) as exc:
        raise ICR5Error("Radio sent invalid ASCII-hex clone data") from exc


def make_frame(command: bytes) -> bytes:
    return PREAMBLE + bytes((RADIO_ADDRESS, PC_ADDRESS)) + command + bytes((TERMINATOR,))


class ICR5:
    def __init__(
        self,
        port: str,
        *,
        timeout: float = 5.0,
        dtr: bool = True,
        rts: bool = False,
        debug: bool = False,
    ) -> None:
        if serial is None:
            raise ICR5Error("pyserial mangler; installer med: python3 -m pip install -r requirements.txt")
        self.port = port
        self.timeout = timeout
        self.dtr = dtr
        self.rts = rts
        self.debug = debug
        self.ser = None

    def __enter__(self) -> "ICR5":
        self.ser = serial.Serial(
            self.port,
            baudrate=9600,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            timeout=self.timeout,
            write_timeout=self.timeout,
            xonxoff=False,
            rtscts=False,
            dsrdtr=False,
        )
        self.ser.dtr = self.dtr
        self.ser.rts = self.rts
        self.ser.reset_input_buffer()
        self.ser.reset_output_buffer()
        time.sleep(0.5)
        return self

    def __exit__(self, *_: object) -> None:
        if self.ser is not None:
            self.ser.close()

    def _log(self, direction: str, data: bytes) -> None:
        if self.debug:
            print(f"{direction} {data.hex(' ')}", file=sys.stderr)

    def send(self, command: bytes) -> bytes:
        assert self.ser is not None
        frame = make_frame(command)
        self._log("-->", frame)
        self.ser.write(frame)
        self.ser.flush()
        return command

    def read_frame(self) -> bytes:
        """Read one CI-V frame and return destination, source, and body."""
        assert self.ser is not None
        read_timeout = self.ser.timeout if self.ser.timeout is not None else self.timeout
        deadline = time.monotonic() + read_timeout
        preamble_seen = 0

        while time.monotonic() < deadline:
            byte = self.ser.read(1)
            if not byte:
                continue
            if byte == b"\xFE":
                preamble_seen += 1
                if preamble_seen >= 2:
                    break
            else:
                preamble_seen = 0
        else:
            raise ICR5Error("Tidsavbrudd mens programmet ventet på radioen")

        body = bytearray()
        while time.monotonic() < deadline:
            byte = self.ser.read(1)
            if not byte:
                continue
            value = byte[0]
            if value == TERMINATOR:
                if len(body) < 3:
                    raise ICR5Error("Radioen sendte en for kort CI-V-ramme")
                result = bytes(body)
                self._log("<--", PREAMBLE + result + bytes((TERMINATOR,)))
                return result
            if value == 0xFC:
                raise ICR5Error("CI-V-kollisjon eller kommunikasjonsfeil")
            if value != 0xFE:
                body.append(value)

        raise ICR5Error("Tidsavbrudd midt i en CI-V-ramme")

    def responses(self, sent_command: bytes | None = None) -> Iterator[bytes]:
        """Yield response bodies, discarding a cable echo when present."""
        while True:
            frame = self.read_frame()
            destination, source, body = frame[0], frame[1], frame[2:]
            if destination not in (PC_ADDRESS, RADIO_ADDRESS):
                continue
            if sent_command is not None and source == PC_ADDRESS and body == sent_command:
                sent_command = None
                continue
            yield body

    def model_info(self) -> bytes:
        command = b"\xE0\x00\x00\x00\x00"
        self.send(command)
        for body in self.responses(command):
            if body[:1] == b"\xFA":
                raise ICR5Error("Radioen avviste forespørselen om modellinformasjon")
            if body[:1] == b"\xE1":
                if len(body) < 5:
                    raise ICR5Error("Ufullstendig modellinformasjon fra radioen")
                return body[1:5]
        raise AssertionError("unreachable")

    def read_image(self, version: bytes) -> bytes:
        command = b"\xE2" + version
        self.send(command)
        image = bytearray()
        expected_address = 0

        for body in self.responses(command):
            if body[:1] == b"\xE5":
                break
            if body[:1] != b"\xE4" or len(body) != 73:
                raise ICR5Error(f"Uventet kloneramme med {len(body)} byte")

            packed = pack_hex(body[1:])
            data_with_header, received_checksum = packed[:-1], packed[-1]
            if checksum(data_with_header) != received_checksum:
                raise ICR5Error("Kontrollsumfeil under lesing fra radio")

            address = int.from_bytes(data_with_header[:2], "big")
            count = data_with_header[2]
            payload = data_with_header[3:]
            if address != expected_address or count != CHUNK_SIZE or len(payload) != count:
                raise ICR5Error(
                    f"Uventet minneblokk: adresse 0x{address:04X}, lengde {count}"
                )
            image.extend(payload)
            expected_address += count
            print(f"\rLeser: {len(image) * 100 // IMAGE_SIZE:3d} %", end="", file=sys.stderr)
        print(file=sys.stderr)

        if len(image) != IMAGE_SIZE:
            raise ICR5Error(f"Ufullstendig bilde: fikk {len(image)}, forventet {IMAGE_SIZE} byte")
        return bytes(image)

    def write_image(self, version: bytes, image: bytes) -> None:
        if len(image) != IMAGE_SIZE:
            raise ICR5Error(f"Bildet må være nøyaktig {IMAGE_SIZE} byte")

        clone_in = b"\xE3" + version
        self.send(clone_in)
        self._discard_optional_echo(clone_in)

        for offset in range(0, IMAGE_SIZE, CHUNK_SIZE):
            payload = image[offset : offset + CHUNK_SIZE]
            packed = offset.to_bytes(2, "big") + bytes((CHUNK_SIZE,)) + payload
            packed += bytes((checksum(packed),))
            command = b"\xE4" + unpack_hex(packed)
            self.send(command)
            self._discard_optional_echo(command)
            print(f"\rSkriver: {(offset + CHUNK_SIZE) * 100 // IMAGE_SIZE:3d} %", end="", file=sys.stderr)
        print(file=sys.stderr)

        termination = b"\xE5Icom Inc.80"
        self.send(termination)
        for body in self.responses(termination):
            if body[:1] == b"\xE6":
                if body[1:2] != b"\x00":
                    raise ICR5Error("Radioen rapporterte feil etter skriving")
                return
        raise AssertionError("unreachable")

    def _discard_optional_echo(self, command: bytes) -> None:
        """Consume a local echo without blocking when the adapter has none."""
        assert self.ser is not None
        old_timeout = self.ser.timeout
        self.ser.timeout = 0.08
        try:
            try:
                frame = self.read_frame()
            except ICR5Error:
                return
            if frame[1] != PC_ADDRESS or frame[2:] != command:
                raise ICR5Error("Uventet svar mens programmet ventet på kabel-ekko")
        finally:
            self.ser.timeout = old_timeout


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Les og skriv Icom IC-R5-klonebilder")
    parser.add_argument("--debug", action="store_true", help="vis rå serielltrafikk")
    parser.add_argument("--timeout", type=float, default=5.0, help="seriell tidsavbrudd i sekunder")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("ports", help="list tilgjengelige seriellporter")
    for name in ("info", "read", "write"):
        command = sub.add_parser(name)
        command.add_argument("port", help="f.eks. /dev/cu.usbserial-... eller COM3")
        command.add_argument("--no-dtr", action="store_true")
        command.add_argument("--rts", action="store_true")
        if name == "read":
            command.add_argument("file", type=Path)
            command.add_argument("--csv", type=Path, help="eksporter også kanalene til CSV")
            command.add_argument(
                "--csv-delimiter",
                choices=(",", ";"),
                default=",",
                help="feltdeler ved CSV-eksport (standard: komma)",
            )
        elif name == "write":
            command.add_argument("file", type=Path)
            command.add_argument(
                "--yes",
                action="store_true",
                help="bekreft at bildet skal overskrive radioens programmering",
            )
    export_command = sub.add_parser("export-csv", help="konverter et .tr5-bilde til lesbar CSV")
    export_command.add_argument("image", type=Path)
    export_command.add_argument("csv", type=Path)
    export_command.add_argument(
        "--delimiter",
        choices=(",", ";"),
        default=",",
        help="feltdeler i CSV-filen (standard: komma)",
    )
    build_command = sub.add_parser("build-image", help="bygg et nytt .tr5-bilde fra CSV og backup")
    build_command.add_argument("base_image", type=Path)
    build_command.add_argument("csv", type=Path)
    build_command.add_argument("output_image", type=Path)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        if args.command in ("export-csv", "build-image"):
            from icr5_memory import export_csv, import_csv

            if args.command == "export-csv":
                image = args.image.read_bytes()
                export_csv(image, args.csv, delimiter=args.delimiter)
                print(f"Eksporterte kanaler til {args.csv}")
            else:
                image = import_csv(args.base_image.read_bytes(), args.csv)
                args.output_image.write_bytes(image)
                print(f"Bygget {args.output_image} ({len(image)} byte)")
            return 0
        if args.command == "ports":
            if list_ports is None:
                raise ICR5Error(
                    "pyserial mangler; installer med: python3 -m pip install -r requirements.txt"
                )
            for port in list_ports.comports():
                print(f"{port.device}\t{port.description}")
            return 0

        with ICR5(
            args.port,
            timeout=args.timeout,
            dtr=not args.no_dtr,
            rts=args.rts,
            debug=args.debug,
        ) as radio:
            version = radio.model_info()
            print(f"Radio funnet, versjon: {version.hex(' ').upper()}", file=sys.stderr)

            if args.command == "info":
                return 0
            if args.command == "read":
                image = radio.read_image(version)
                args.file.write_bytes(image)
                print(f"Skrev backup til {args.file} ({len(image)} byte)")
                if args.csv:
                    from icr5_memory import export_csv

                    export_csv(image, args.csv, delimiter=args.csv_delimiter)
                    print(f"Eksporterte kanaler til {args.csv}")
                return 0
            if not args.yes:
                raise ICR5Error("Skriving krever --yes. Ta alltid backup med read først.")
            image = args.file.read_bytes()
            radio.write_image(version, image)
            print("Skriving fullført. Slå radioen av og på før bruk.")
            return 0
    except (ICR5Error, OSError) as exc:
        print(f"Feil: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
