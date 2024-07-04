*server-status MONITOR*
=====================

### A script that monitors and extracts requested URLs and clients connected to the service by exploiting publicly accessible Apache server-status instances.

### [ Inspired from the Blog Post: Exploiting Misconfigured Apache server-status Instances with server-status_PWN](https://mazinahmed.net/blog/exploiting-misconfigured-apache-server-status-instances/)

---

## What is Apache server-status?

Apache server-status is an Apache monitoring instance, available by default at `http://example.com/server-status`. In normal cases, the server-status instance is not accessible by non-local origin IPs. However, due to misconfiguration, it can be publicly accessible. This leads anyone to view the great amount of data by server-status.

A part of "interesting/severe" data to long-term attackers and red-teamers is the exposure of clients' IP addresses and requested URLs on the Apache service, which an exposed Apache server-status provides. Also, Apache server-status output is viewed on the real-time.

## What type of data can be exposed?

* All requested URLs by all Hosts/VHosts on the Apache server.
	* This includes:
		* Hidden and obscure files and directories.
		* Session Tokens on GET REQUEST_URI (eg.. `https://example.com/?token=123`). If tokens are passed through GET HTTP method, it will be exposed, no matter what SSL encryption is used.
* All clients' IP addresses along with URLs the clients have requested.


## What do we need as attackers?

We need a script that constantly monitors the exposed Apache server-status, and extracts all new URLs, and save them for later testing.

Also, if we are performing an intelligence engagement, we would need all IPs that interacts with the Apache server that hosts our target website, along with requested URLs. Then we need to constantly monitor the service on the hour.

---

# Introducing *server-status MONITOR*

server-status MONITOR constantly requests and parse Apache server-status page for any new event. Whenever a new URL is requested and a new client IP address is used, it will be logged and reported.

It includes an option for saving unique URLs in a file.


## **Usage**

`python3 server-status_monitor.py -u 'http://example.com/server-status -o output.txt'`


## **Why I created this?**

* To prove the severity of having an exposed Apache server-status. 
* Modified the original script to a different format because the script didn't work to the exposed server-status format I encountered.
* I needed an actual PoC exploit.

# **Requirements**

* Python2 or Python3
* requests
* bs4
