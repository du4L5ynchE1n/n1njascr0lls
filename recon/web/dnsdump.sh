#!/usr/bin/env bash
#works only with grep -P option

input="$1"
response=$(curl -i https://dnsdumpster.com)
cookie=$(echo "$response" | grep -i 'set-cookie' | awk '{print $2}')
csrf_midtoken=$(echo "$response" | grep -oP 'name="csrfmiddlewaretoken" value="\K[^"]+')
curl -s -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36" "https://dnsdumpster.com/" -H "Cookie: $cookie" -H "Referer: https://dnsdumpster.com" -d "csrfmiddlewaretoken=$csrf_midtoken&targetip=$input&user=free" | html2text | grep -A 1000 "Host Records (A)" | grep -Eo "([a-zA-Z0-9.-]+)\s+([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)"
