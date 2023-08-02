
# Web Recon Scripts

scripts for information gathering useful for external reconaissance and web testing


## Usage/Examples

Query Host Records (A) from https://dnsdumpster.com/

```bash
dnsdump.sh <domain>
dnsdump.sh <domain> | cut -d " " -f1  //get FQDN only
dnsdump.sh <domain> | awk '{print $NF}' //get IP only
```
