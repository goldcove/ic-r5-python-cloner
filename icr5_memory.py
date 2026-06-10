"""Human-readable CSV conversion for Icom IC-R5 memory channels."""

from __future__ import annotations

import csv
from dataclasses import dataclass, fields
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from pathlib import Path

from icr5 import IMAGE_SIZE
from icr5_errors import ICR5Error


CHANNEL_COUNT = 1000
RECORD_SIZE = 16
FREQ_ADDR = 0x0000
MODE_ADDR = 0x0003
OFFSET_ADDR = 0x0004
CTCSS_ADDR = 0x0006
DCS_ADDR = 0x0007
STEP_ADDR = 0x0008
LABEL_ADDR = 0x000B
BANK_ADDR = 0x5080

STEPS = ("5", "6.25", "8.33", "9", "10", "12.5", "15", "20", "25", "30", "50", "100")
STEP_TO_CODE = {step: code for code, step in enumerate(STEPS)}
INTERNAL_STEP = {"5": Decimal("5"), "6.25": Decimal("6.25"), "8.33": Decimal("8.33"), "9": Decimal("9")}
WORKING_STEP = {
    "5": "5", "6.25": "6.25", "8.33": "8.33", "9": "9",
    "10": "5", "12.5": "6.25", "15": "5", "20": "5",
    "25": "5", "30": "5", "50": "5", "100": "5",
}
MODES = ("NFM", "WFM", "AM")
TONE_FLAGS = ("", "t", "b", "d", "p")
SKIP_VALUES = ("", "skip", "pskip")
BANKS = tuple("ABCDEFGHJL NOPQRTUY".replace(" ", ""))

CTCSS_VALUES = (
    "67.0", "69.3", "71.9", "74.4", "77.0", "79.7", "82.5", "85.4",
    "88.5", "91.5", "94.8", "97.4", "100.0", "103.5", "107.2", "110.9",
    "114.8", "118.8", "123.0", "127.3", "131.8", "136.5", "141.3",
    "146.2", "151.4", "156.7", "159.8", "162.2", "165.5", "167.9",
    "171.3", "173.8", "177.3", "179.9", "183.5", "186.2", "189.9",
    "192.8", "196.6", "199.5", "203.5", "206.5", "210.7", "218.1",
    "225.7", "229.1", "233.6", "241.8", "250.3", "254.1",
)
DCS_VALUES = (
    "023", "025", "026", "031", "032", "036", "043", "047", "051", "053",
    "054", "065", "071", "072", "073", "074", "114", "115", "116", "122",
    "125", "131", "132", "134", "143", "145", "152", "155", "156", "162",
    "165", "172", "174", "205", "212", "223", "225", "226", "243", "244",
    "245", "246", "251", "252", "255", "261", "263", "265", "266", "271",
    "274", "306", "311", "315", "325", "331", "332", "343", "346", "351",
    "356", "364", "365", "371", "411", "412", "413", "423", "431", "432",
    "445", "446", "452", "454", "455", "462", "464", "465", "466", "503",
    "506", "516", "523", "526", "532", "546", "565", "606", "612", "624",
    "627", "631", "632", "654", "662", "664", "703", "712", "723", "731",
    "732", "734", "743", "754",
)
LABEL_CHARS = "        ()*+ -,/0123456789|  =   ABCDEFGHIJKLMNOPQRSTUVWXYZ"
LABEL_DECODE = {index: char for index, char in enumerate(LABEL_CHARS) if char != " " or index == 0}
LABEL_ENCODE = {char: index for index, char in LABEL_DECODE.items()}


@dataclass
class Channel:
    Mem: int
    Enabled: str = "no"
    MHz: str = ""
    Mode: str = "NFM"
    Step: str = "5"
    Offset: str = "0.00000"
    Duplex: str = ""
    TSQL: str = ""
    CTCSS: str = "67.0"
    DCS: str = "023"
    Polarity: str = "n"
    Skip: str = ""
    Bank: str = ""
    Ch: str = ""
    Label: str = ""


CSV_FIELDS = [field.name for field in fields(Channel)]


def _get_field(byte: int, first: int, last: int) -> int:
    width = last - first + 1
    shift = 7 - last
    return (byte >> shift) & ((1 << width) - 1)


def _set_field(byte: int, first: int, last: int, value: int) -> int:
    width = last - first + 1
    shift = 7 - last
    mask = ((1 << width) - 1) << shift
    return (byte & ~mask) | ((value << shift) & mask)


def _decimal(value: str, name: str, channel: int) -> Decimal:
    try:
        return Decimal(value)
    except InvalidOperation as exc:
        raise ICR5Error(f"Kanal {channel}: ugyldig {name}: {value!r}") from exc


def _format_mhz(value: Decimal) -> str:
    return f"{value.quantize(Decimal('0.00001'), rounding=ROUND_HALF_UP):.5f}"


def _decode_frequency(raw: bytes) -> Decimal:
    code = _get_field(raw[2], 2, 3)
    step = tuple(INTERNAL_STEP.values())[code]
    multiplier = (_get_field(raw[2], 6, 7) << 16) | (raw[1] << 8) | raw[0]
    return Decimal(multiplier) * step / Decimal(1000)


def _encode_frequency(
    value: Decimal,
    display_step: str,
    channel: int,
    preferred_code: int | None = None,
) -> bytes:
    if value == 0:
        return b"\x00\x00\x00"
    if not Decimal("0.100") <= value <= Decimal("1309.995"):
        raise ICR5Error(f"Kanal {channel}: frekvens utenfor området: {value}")
    preferred = tuple(INTERNAL_STEP).index(WORKING_STEP[display_step])
    codes = [preferred_code, preferred, 0, 1, 2, 3]
    for code in dict.fromkeys(code for code in codes if code is not None):
        step = tuple(INTERNAL_STEP.values())[code]
        multiplier = int((value * 1000 / step).to_integral_value(rounding=ROUND_HALF_UP))
        encoded_value = Decimal(multiplier) * step / Decimal(1000)
        if abs(encoded_value - value) <= Decimal("0.00001") and multiplier < 1 << 18:
            final = _set_field(0, 2, 3, code)
            final = _set_field(final, 6, 7, multiplier >> 16)
            return bytes((multiplier & 0xFF, (multiplier >> 8) & 0xFF, final))
    raise ICR5Error(f"Kanal {channel}: frekvensen {value} MHz kan ikke kodes av IC-R5")


def _decode_offset(raw: bytes, multiplier_byte: int) -> Decimal:
    code = _get_field(multiplier_byte, 0, 1)
    step = tuple(INTERNAL_STEP.values())[code]
    multiplier = raw[0] | (raw[1] << 8)
    return Decimal(multiplier) * step / Decimal(1000)


def _encode_offset(
    value: Decimal,
    display_step: str,
    channel: int,
    preferred_code: int | None = None,
) -> tuple[bytes, int]:
    if not Decimal(0) <= value <= Decimal("159.995"):
        raise ICR5Error(f"Kanal {channel}: ugyldig offset: {value}")
    preferred = tuple(INTERNAL_STEP).index(WORKING_STEP[display_step])
    codes = [preferred_code, preferred, 0, 1, 2, 3]
    for code in dict.fromkeys(code for code in codes if code is not None):
        step = tuple(INTERNAL_STEP.values())[code]
        multiplier = int((value * 1000 / step).to_integral_value(rounding=ROUND_HALF_UP))
        encoded_value = Decimal(multiplier) * step / Decimal(1000)
        if abs(encoded_value - value) <= Decimal("0.00001") and multiplier <= 0xFFFF:
            return multiplier.to_bytes(2, "little"), code
    raise ICR5Error(f"Kanal {channel}: offset {value} MHz kan ikke kodes av IC-R5")


def _decode_label(raw: bytes) -> str:
    values = (
        (_get_field(raw[0], 4, 7) << 2) | _get_field(raw[1], 0, 1),
        _get_field(raw[1], 2, 7),
        _get_field(raw[2], 0, 5),
        (_get_field(raw[2], 6, 7) << 4) | _get_field(raw[3], 0, 3),
        (_get_field(raw[3], 4, 7) << 2) | _get_field(raw[4], 0, 1),
        _get_field(raw[4], 2, 7),
    )
    return "".join(LABEL_DECODE.get(value, " ") for value in values).rstrip()


def _encode_label(label: str, channel: int) -> bytes:
    label = label.upper()[:6].ljust(6)
    unsupported = sorted({char for char in label if char not in LABEL_ENCODE})
    if unsupported:
        raise ICR5Error(f"Kanal {channel}: tegn støttes ikke i etikett: {''.join(unsupported)!r}")
    n = [LABEL_ENCODE[char] for char in label]
    raw = [0] * 5
    raw[0] = _set_field(raw[0], 4, 7, n[0] >> 2)
    raw[1] = _set_field(raw[1], 0, 1, n[0] & 3)
    raw[1] = _set_field(raw[1], 2, 7, n[1])
    raw[2] = _set_field(raw[2], 0, 5, n[2])
    raw[2] = _set_field(raw[2], 6, 7, n[3] >> 4)
    raw[3] = _set_field(raw[3], 0, 3, n[3] & 15)
    raw[3] = _set_field(raw[3], 4, 7, n[4] >> 2)
    raw[4] = _set_field(raw[4], 0, 1, n[4] & 3)
    raw[4] = _set_field(raw[4], 2, 7, n[5])
    return bytes(raw)


def decode_channels(image: bytes) -> list[Channel]:
    if len(image) != IMAGE_SIZE:
        raise ICR5Error(f"Bildet må være {IMAGE_SIZE} byte")
    channels = []
    for number in range(CHANNEL_COUNT):
        base = number * RECORD_SIZE
        bank_base = BANK_ADDR + number * 2
        bank_byte, bank_channel_byte = image[bank_base : bank_base + 2]
        enabled = bank_byte != 0xFF
        mode_byte = image[MODE_ADDR + base]
        dcs_byte = image[DCS_ADDR + base]
        bank_code = _get_field(bank_byte, 3, 7)
        step_code = _get_field(image[STEP_ADDR + base], 0, 3)
        channel = Channel(
            Mem=number,
            Enabled="yes" if enabled else "no",
            MHz=_format_mhz(_decode_frequency(image[FREQ_ADDR + base : FREQ_ADDR + base + 3])) if enabled else "",
            Mode=MODES[_get_field(mode_byte, 4, 5)] if _get_field(mode_byte, 4, 5) < len(MODES) else "NFM",
            Step=STEPS[step_code] if step_code < len(STEPS) else "5",
            Offset=_format_mhz(_decode_offset(image[OFFSET_ADDR + base : OFFSET_ADDR + base + 2], image[2 + base])),
            Duplex={1: "-", 2: "+"}.get(_get_field(mode_byte, 6, 7), ""),
            TSQL={1: "t", 2: "b", 3: "d", 4: "p"}.get(_get_field(mode_byte, 0, 3), ""),
            CTCSS=CTCSS_VALUES[image[CTCSS_ADDR + base]] if image[CTCSS_ADDR + base] < len(CTCSS_VALUES) else "67.0",
            DCS=DCS_VALUES[_get_field(dcs_byte, 1, 7)] if _get_field(dcs_byte, 1, 7) < len(DCS_VALUES) else "023",
            Polarity="r" if _get_field(dcs_byte, 0, 0) else "n",
            Skip={1: "skip", 3: "pskip"}.get(_get_field(bank_byte, 1, 2), ""),
            Bank=BANKS[bank_code] if bank_code < len(BANKS) else "",
            Ch=str(_get_field(bank_channel_byte, 1, 7)) if bank_code < len(BANKS) and bank_channel_byte != 0xFF else "",
            Label=_decode_label(image[LABEL_ADDR + base : LABEL_ADDR + base + 5]),
        )
        channels.append(channel)
    return channels


def export_csv(image: bytes, path: Path, delimiter: str = ",") -> None:
    if delimiter not in (",", ";"):
        raise ICR5Error("CSV-feltdeler må være komma eller semikolon")
    with path.open("w", newline="", encoding="utf-8-sig") as handle:
        writer = csv.DictWriter(handle, fieldnames=CSV_FIELDS, delimiter=delimiter)
        writer.writeheader()
        for channel in decode_channels(image):
            writer.writerow(channel.__dict__)


def _validate(channel: Channel) -> None:
    number = channel.Mem
    channel.Enabled = channel.Enabled.strip().lower()
    if channel.Enabled not in ("yes", "no"):
        raise ICR5Error(f"Kanal {number}: Enabled må være yes eller no")
    if channel.Enabled == "no":
        return
    channel.Mode = channel.Mode.strip().upper()
    channel.Step = channel.Step.strip()
    channel.Duplex = channel.Duplex.strip()
    channel.TSQL = channel.TSQL.strip().lower()
    channel.CTCSS = channel.CTCSS.strip()
    channel.DCS = channel.DCS.strip().zfill(3)
    channel.Polarity = channel.Polarity.strip().lower()
    channel.Skip = channel.Skip.strip().lower()
    channel.Bank = channel.Bank.strip().upper()
    channel.Ch = channel.Ch.strip()
    if channel.Mode not in MODES:
        raise ICR5Error(f"Kanal {number}: ugyldig Mode {channel.Mode!r}")
    if channel.Step not in STEPS:
        raise ICR5Error(f"Kanal {number}: ugyldig Step {channel.Step!r}")
    if channel.Duplex not in ("", "+", "-"):
        raise ICR5Error(f"Kanal {number}: ugyldig Duplex {channel.Duplex!r}")
    if channel.TSQL not in TONE_FLAGS:
        raise ICR5Error(f"Kanal {number}: ugyldig TSQL {channel.TSQL!r}")
    if channel.CTCSS not in CTCSS_VALUES:
        raise ICR5Error(f"Kanal {number}: ugyldig CTCSS {channel.CTCSS!r}")
    if channel.DCS not in DCS_VALUES:
        raise ICR5Error(f"Kanal {number}: ugyldig DCS {channel.DCS!r}")
    if channel.Polarity not in ("n", "r", "normal", "reverse"):
        raise ICR5Error(f"Kanal {number}: ugyldig Polarity {channel.Polarity!r}")
    channel.Polarity = channel.Polarity[0]
    if channel.Skip not in SKIP_VALUES:
        raise ICR5Error(f"Kanal {number}: ugyldig Skip {channel.Skip!r}")
    if channel.Bank and channel.Bank not in BANKS:
        raise ICR5Error(f"Kanal {number}: ugyldig Bank {channel.Bank!r}")
    if channel.Ch and (not channel.Ch.isdigit() or not 0 <= int(channel.Ch) <= 99):
        raise ICR5Error(f"Kanal {number}: bankkanal må være 0-99")
    if bool(channel.Bank) != bool(channel.Ch):
        raise ICR5Error(f"Kanal {number}: Bank og Ch må enten begge være satt eller begge tomme")
    if len(channel.Label) > 6:
        raise ICR5Error(f"Kanal {number}: Label kan ha maksimalt 6 tegn")


def import_csv(base_image: bytes, path: Path) -> bytes:
    if len(base_image) != IMAGE_SIZE:
        raise ICR5Error(f"Grunnbildet må være {IMAGE_SIZE} byte")
    image = bytearray(base_image)
    original_channels = decode_channels(base_image)
    seen = set()
    bank_slots = set()
    with path.open(newline="", encoding="utf-8-sig") as handle:
        sample = handle.read(4096)
        handle.seek(0)
        try:
            delimiter = csv.Sniffer().sniff(sample, delimiters=",;").delimiter
        except csv.Error as exc:
            raise ICR5Error("Kunne ikke avgjøre om CSV bruker komma eller semikolon") from exc
        reader = csv.DictReader(handle, delimiter=delimiter)
        missing = set(CSV_FIELDS) - set(reader.fieldnames or ())
        if missing:
            raise ICR5Error(f"CSV mangler kolonner: {', '.join(sorted(missing))}")
        for line, row in enumerate(reader, 2):
            try:
                number = int(row["Mem"])
            except (TypeError, ValueError) as exc:
                raise ICR5Error(f"CSV-linje {line}: ugyldig Mem") from exc
            if not 0 <= number < CHANNEL_COUNT or number in seen:
                raise ICR5Error(f"CSV-linje {line}: ugyldig eller duplisert Mem {number}")
            seen.add(number)
            channel = Channel(**{name: (number if name == "Mem" else row.get(name, "")) for name in CSV_FIELDS})
            _validate(channel)
            _encode_channel(image, channel, original_channels[number])
            if channel.Enabled == "yes" and channel.Bank:
                slot = (channel.Bank, int(channel.Ch))
                if slot in bank_slots:
                    raise ICR5Error(f"Kanal {number}: bankplass {channel.Bank}{channel.Ch} er duplisert")
                bank_slots.add(slot)
    if not seen:
        raise ICR5Error("CSV-filen inneholder ingen kanalrader")
    return bytes(image)


def _encode_channel(image: bytearray, channel: Channel, original: Channel) -> None:
    number = channel.Mem
    base = number * RECORD_SIZE
    bank_base = BANK_ADDR + number * 2
    if channel.Enabled == "no":
        if original.Enabled == "no":
            return
        image[FREQ_ADDR + base : FREQ_ADDR + base + 3] = b"\x00\x00\x00"
        image[LABEL_ADDR + base : LABEL_ADDR + base + 5] = b"\x00" * 5
        image[bank_base : bank_base + 2] = b"\xFF\xFF"
        return

    new_channel = original.Enabled == "no"
    frequency = _decimal(channel.MHz, "MHz", number)
    offset = _decimal(channel.Offset or "0", "Offset", number)
    if new_channel or channel.MHz != original.MHz:
        preferred = _get_field(image[2 + base], 2, 3)
        image[FREQ_ADDR + base : FREQ_ADDR + base + 3] = _encode_frequency(
            frequency, channel.Step, number, preferred
        )
    if new_channel or channel.Step != original.Step:
        image[STEP_ADDR + base] = _set_field(
            image[STEP_ADDR + base], 0, 3, STEP_TO_CODE[channel.Step]
        )
    if new_channel or channel.Label != original.Label:
        image[LABEL_ADDR + base : LABEL_ADDR + base + 5] = _encode_label(channel.Label, number)

    mode = image[MODE_ADDR + base]
    if new_channel or channel.Mode != original.Mode:
        mode = _set_field(mode, 4, 5, MODES.index(channel.Mode))
    if new_channel or channel.Duplex != original.Duplex:
        mode = _set_field(mode, 6, 7, {"": 0, "-": 1, "+": 2}[channel.Duplex])
    if new_channel or channel.TSQL != original.TSQL:
        mode = _set_field(mode, 0, 3, TONE_FLAGS.index(channel.TSQL))
    image[MODE_ADDR + base] = mode

    if new_channel or channel.Offset != original.Offset:
        preferred = _get_field(image[2 + base], 0, 1)
        offset_raw, offset_code = _encode_offset(offset, channel.Step, number, preferred)
        image[OFFSET_ADDR + base : OFFSET_ADDR + base + 2] = offset_raw
        image[2 + base] = _set_field(image[2 + base], 0, 1, offset_code)
    if new_channel or channel.CTCSS != original.CTCSS:
        image[CTCSS_ADDR + base] = CTCSS_VALUES.index(channel.CTCSS)
    if new_channel or channel.DCS != original.DCS or channel.Polarity != original.Polarity:
        image[DCS_ADDR + base] = _set_field(0, 1, 7, DCS_VALUES.index(channel.DCS))
        image[DCS_ADDR + base] = _set_field(
            image[DCS_ADDR + base], 0, 0, channel.Polarity == "r"
        )

    bank_changed = (
        new_channel
        or channel.Skip != original.Skip
        or channel.Bank != original.Bank
        or channel.Ch != original.Ch
    )
    if bank_changed:
        bank_byte = 0x1F
        bank_byte = _set_field(bank_byte, 1, 2, {"": 0, "skip": 1, "pskip": 3}[channel.Skip])
        if channel.Bank:
            bank_byte = _set_field(bank_byte, 3, 7, BANKS.index(channel.Bank))
            bank_channel = int(channel.Ch)
        else:
            bank_byte = _set_field(bank_byte, 3, 7, 31)
            bank_channel = 0xFF
        image[bank_base] = bank_byte
        image[bank_base + 1] = bank_channel
