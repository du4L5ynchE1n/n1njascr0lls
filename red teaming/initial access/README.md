
# Initial Access Payloads

scripts for automating creation of payloads for initial access TTPs


## Usage/Examples

Shortcut Files as Initial Access Payloads


```powershell
#modify the amsibypass,url and dlpath values
generate-lnkv1.ps1 //for executables
generate-lnkv2.ps1 //for powershell stager in memory


```

HTML Smuggling

```bash
# first argument is the file to be encoded to base64
./smuggle.sh <file> -f <filename to be downloaded> -o <html filename>
```
