import argparse
import requests
import re
import time
import urllib3

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Function to send request and fetch server-status page
def fetch_server_status(url):
    try:
        print(f"Fetching server status from: {url}")
        response = requests.get(url, verify=False)
        if response.status_code == 200:
            return response.text
        else:
            print(f"Error fetching server status: HTTP {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"Error fetching server status: {e}")
    return None

# Function to parse server-status response and extract new URLs
def parse_server_status(response_text):
    new_urls = []
    if response_text:
        # Regex pattern to match URLs from server-status response
        regex_pattern = r'<td nowrap>([\w.-]+:\d+)</td><td nowrap>(\w+)\s+([^<]+)</td></tr>'
        matches = re.finditer(regex_pattern, response_text, re.MULTILINE)
        for match in matches:
            host_port = match.group(1)
            http_method = match.group(2)
            request_uri = match.group(3)
            
            # Construct full URL
            full_url = f"http://{host_port}{request_uri}"
            new_urls.append(full_url)

        print("Extracted New URLs:")
        for newurl in new_urls:
            print(f"New URL found: {newurl}")
    return new_urls

# Main function to monitor server-status and print new URLs
def main(server_status_url, output_file, interval=10):
    while True:
        server_status_response = fetch_server_status(server_status_url)
        if server_status_response:
            new_urls = parse_server_status(server_status_response)
            if output_file:
                with open(output_file, 'a') as f:
                    for newurl in new_urls:
                        f.write(f"New URL found: {newurl}\n")
        time.sleep(interval)

if __name__ == "__main__":
    # Setup argument parsing
    parser = argparse.ArgumentParser(description="Server status monitor script")
    parser.add_argument("-u", "--url", required=True, help="URL of the server status page")
    parser.add_argument("-o", "--output", default=None, help="Output file to write new URLs (optional)")

    # Parse arguments from command line
    args = parser.parse_args()

    # Run the main function with parsed arguments
    main(args.url, args.output)
