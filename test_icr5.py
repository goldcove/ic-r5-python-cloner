import tempfile
import unittest
from pathlib import Path

from icr5 import IMAGE_SIZE, checksum, make_frame, pack_hex, unpack_hex
from icr5_memory import Channel, decode_channels, export_csv, import_csv


class ProtocolTests(unittest.TestCase):
    def test_checksum_makes_zero_sum(self):
        data = bytes.fromhex("00102001020304")
        self.assertEqual((sum(data) + checksum(data)) & 0xFF, 0)

    def test_ascii_hex_round_trip(self):
        data = bytes(range(256))
        self.assertEqual(pack_hex(unpack_hex(data)), data)

    def test_command_frame(self):
        self.assertEqual(
            make_frame(b"\xE0\x00\x00\x00\x00"),
            bytes.fromhex("FE FE EE EF E0 00 00 00 00 FD"),
        )

    def test_image_size_matches_tk5(self):
        self.assertEqual(IMAGE_SIZE, 28_672)

    def test_csv_round_trip_preserves_image(self):
        image = bytearray(b"\x00" * IMAGE_SIZE)
        for channel in range(1000):
            image[0x5080 + channel * 2 : 0x5082 + channel * 2] = b"\xFF\xFF"
        with tempfile.TemporaryDirectory() as directory:
            csv_path = Path(directory) / "channels.csv"
            export_csv(bytes(image), csv_path)
            rebuilt = import_csv(bytes(image), csv_path)
        self.assertEqual(rebuilt, bytes(image))

    def test_semicolon_csv_round_trip(self):
        image = bytearray(b"\x00" * IMAGE_SIZE)
        for channel in range(1000):
            image[0x5080 + channel * 2 : 0x5082 + channel * 2] = b"\xFF\xFF"
        with tempfile.TemporaryDirectory() as directory:
            csv_path = Path(directory) / "channels.csv"
            export_csv(bytes(image), csv_path, delimiter=";")
            self.assertIn("Mem;Enabled;MHz", csv_path.read_text(encoding="utf-8-sig").splitlines()[0])
            rebuilt = import_csv(bytes(image), csv_path)
        self.assertEqual(rebuilt, bytes(image))

    def test_channel_encode_decode(self):
        image = bytes(b"\xFF" * IMAGE_SIZE)
        with tempfile.TemporaryDirectory() as directory:
            csv_path = Path(directory) / "channels.csv"
            export_csv(image, csv_path)
            rows = csv_path.read_text(encoding="utf-8-sig").splitlines()
            header = rows[0]
            rows[1] = "0,yes,145.50000,NFM,12.5,0.60000,-,t,88.5,023,n,skip,A,1,CALL"
            csv_path.write_text("\n".join([header, *rows[1:]]) + "\n", encoding="utf-8-sig")
            rebuilt = import_csv(image, csv_path)
        channel = decode_channels(rebuilt)[0]
        self.assertEqual(
            channel,
            Channel(0, "yes", "145.50000", "NFM", "12.5", "0.60000", "-", "t",
                    "88.5", "023", "n", "skip", "A", "1", "CALL"),
        )

    def test_display_step_does_not_control_frequency_encoding(self):
        image = bytearray(b"\xFF" * IMAGE_SIZE)
        image[0:3] = bytes((0xE9, 0x03, 0x00))  # 1001 * 5 kHz = 5.005 MHz
        image[8] = 5  # Displayed tuning step is 12.5 kHz.
        image[0x5080:0x5082] = b"\x1F\xFF"
        with tempfile.TemporaryDirectory() as directory:
            csv_path = Path(directory) / "channels.csv"
            export_csv(bytes(image), csv_path)
            rebuilt = import_csv(bytes(image), csv_path)
        self.assertEqual(rebuilt, bytes(image))


if __name__ == "__main__":
    unittest.main()
