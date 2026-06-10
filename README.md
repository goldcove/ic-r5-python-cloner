# IC-R5 Python-kloner

Dette er en liten kommandolinjeport av den grunnleggende
klonefunksjonen i `tk5 0.6`: identifiser radioen, les et rått
minnebilde og skriv et tidligere lagret bilde tilbake.

## Viktig

Bruk en korrekt CI-V/TTL-adapter for IC-R5. En PL2303-brikke alene
garanterer ikke riktige elektriske nivåer. Ikke koble en vanlig
RS-232-utgang direkte til radioen.

Ta alltid en backup før skriving. Et gyldig råbilde er nøyaktig
28 672 byte. Programmet nekter å skrive andre filstørrelser og krever
det eksplisitte flagget `--yes`.

## Oppsett

```sh
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
```

## Bruk

Finn seriellporten:

```sh
python3 icr5.py ports
```

Test kommunikasjon:

```sh
python3 icr5.py info /dev/cu.usbserial-XXXX
```

Les radioen til både rå backup og menneskelesbar CSV:

```sh
python3 icr5.py read /dev/cu.usbserial-XXXX original.tr5 --csv kanaler.csv
```

For semikolon som feltdeler, vanlig i norsk Excel:

```sh
python3 icr5.py read /dev/cu.usbserial-XXXX original.tr5 \
  --csv kanaler.csv --csv-delimiter ";"
```

Rediger `kanaler.csv` i et regneark eller tekstprogram. Behold
kolonnenavnene. `Enabled` må være `yes` eller `no`; sett `no` for å
slette en kanal. Ved import oppdages `,` eller `;` automatisk.

Bygg et nytt bilde fra CSV-en og den urørte backupen:

```sh
python3 icr5.py build-image original.tr5 kanaler.csv endret.tr5
```

Skriv det nye bildet:

```sh
python3 icr5.py write /dev/cu.usbserial-XXXX endret.tr5 --yes
```

Standardinnstillingen er 9600 baud, 8N1, DTR på og RTS av, tilsvarende
TK5-oppsettet. Enkelte adaptere trenger `--no-dtr` eller `--rts`.

CSV-en inneholder alle 1000 kanalplasser. Følgende verdier brukes:

- `Mode`: `NFM`, `WFM` eller `AM`
- `Step`: `5`, `6.25`, `8.33`, `9`, `10`, `12.5`, `15`, `20`, `25`,
  `30`, `50` eller `100`
- `Duplex`: tom, `+` eller `-`
- `TSQL`: tom, `t`, `b`, `d` eller `p`
- `Polarity`: `n` eller `r`
- `Skip`: tom, `skip` eller `pskip`
- `Bank`: tom eller en av `A B C D E F G H J L N O P Q R T U Y`
- `Ch`: `0` til `99`; må være satt sammen med `Bank`

Bankbokstavene `I`, `K`, `M`, `S`, `V`, `W`, `X` og `Z` finnes ikke
på IC-R5 og blir avvist ved import.

Originalbildet er nødvendig ved CSV-import fordi det inneholder flere
radioinnstillinger enn kanalene. Disse bevares uendret. Når en
eksportert CSV bygges uten endringer, blir det nye `.tr5`-bildet
byte-for-byte identisk med originalbildet.

`Step` er kanalens viste søke-/innstillingssteg. IC-R5 lagrer
frekvensens interne kodingssteg separat. Programmet bevarer denne
kodingen for uendrede kanaler og velger automatisk en gyldig intern
koding når frekvensen endres.
