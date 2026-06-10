# IC-R5 Python Cloner

This is a small command-line port of the core cloning functionality in
`tk5 0.6`. It can identify the radio, read a raw memory image, export
memory channels to CSV, rebuild an image from edited CSV data, and write
the image back to the radio.

## Important

Use a proper CI-V/TTL adapter for the IC-R5. A PL2303 chip alone does not
guarantee correct electrical levels. Do not connect a normal RS-232
output directly to the radio.

Always create a backup before writing. A valid raw image is exactly
28,672 bytes. The program rejects other image sizes and requires the
explicit `--yes` option before writing.

## Setup

```sh
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
```

## Usage

List serial ports:

```sh
python3 icr5.py ports
```

Test communication:

```sh
python3 icr5.py info /dev/cu.usbserial-XXXX
```

Read the radio to both a raw backup and a human-readable CSV file:

```sh
python3 icr5.py read /dev/cu.usbserial-XXXX original.tr5 --csv channels.csv
```

Use a semicolon delimiter, which is common with European spreadsheet
settings:

```sh
python3 icr5.py read /dev/cu.usbserial-XXXX original.tr5 \
  --csv channels.csv --csv-delimiter ";"
```

Edit `channels.csv` in a spreadsheet or text editor. Keep the column
names unchanged. `Enabled` must be `yes` or `no`; use `no` to delete a
channel. Import automatically detects comma or semicolon delimiters.

Build a new image from the CSV file and the untouched backup:

```sh
python3 icr5.py build-image original.tr5 channels.csv modified.tr5
```

Write the new image:

```sh
python3 icr5.py write /dev/cu.usbserial-XXXX modified.tr5 --yes
```

The default serial configuration is 9600 baud, 8N1, DTR enabled, and
RTS disabled, matching TK5. Some adapters may require `--no-dtr` or
`--rts`.

The CSV file contains all 1,000 memory channel slots. Supported values:

- `Mode`: `NFM`, `WFM`, or `AM`
- `Step`: `5`, `6.25`, `8.33`, `9`, `10`, `12.5`, `15`, `20`, `25`,
  `30`, `50`, or `100`
- `Duplex`: empty, `+`, or `-`
- `TSQL`: empty, `t`, `b`, `d`, or `p`
- `Polarity`: `n` or `r`
- `Skip`: empty, `skip`, or `pskip`
- `Bank`: empty or one of `A B C D E F G H J L N O P Q R T U Y`
- `Ch`: `0` through `99`; it must be set together with `Bank`

Bank letters `I`, `K`, `M`, `S`, `V`, `W`, `X`, and `Z` do not exist
on the IC-R5 and are rejected during import.

The original image is required during CSV import because it contains
radio settings beyond the memory channels. These settings are preserved.
If an exported CSV file is rebuilt without changes, the resulting
`.tr5` image is byte-for-byte identical to the original image.

`Step` is the channel's displayed tuning step. The IC-R5 stores the
internal frequency encoding step separately. The program preserves that
encoding for unchanged channels and automatically selects a valid
internal encoding when a frequency is changed.
