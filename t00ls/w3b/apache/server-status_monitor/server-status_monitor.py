import argparse
import requests
import re
import time
import urllib3
from datetime import datetime

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Global variable to store previously seen URLs
seen_urls = set()

# ANSI color codes
YELLOW = '\033[93m'
RESET = '\033[0m'
RED = '\033[91m'

# Function to send request and fetch server-status page
def fetch_server_status(url):
    try:
        now = datetime.now()
        timestamp = now.strftime("%Y-%m-%d %H:%M:%S")
        print(f"Fetching server status from: {url} ({timestamp})")
        
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
            full_url = f"{http_method} {host_port}{request_uri}"
            new_urls.append(full_url)
        
        new_urls_to_print = []
        for newurl in new_urls:
            if newurl not in seen_urls:
                seen_urls.add(newurl)
                new_urls_to_print.append(newurl)
                print(f"{YELLOW}[New URL Found]{RESET} {newurl}")
        
        return new_urls_to_print

    return []

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
            
            if not new_urls:
                print(f"{RED}[No new URL found]{RESET}")
        
        time.sleep(interval)

if __name__ == "__main__":
    # Setup argument parsing
    parser = argparse.ArgumentParser(description="Server status monitor script")
    parser.add_argument("-u", "--url", required=True, help="URL of the server status page")
    parser.add_argument("-o", "--output", default=None, help="Output file to write new URLs (optional)")
    parser.add_argument("-i", "--interval", type=int, default=10, help="Interval in seconds (default: 10)")

    # Parse arguments from command line
    args = parser.parse_args()

    # Run the main function with parsed arguments
    main(args.url, args.output, args.interval)
