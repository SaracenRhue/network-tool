# Network Performance Test Script

This Bash script performs a comprehensive network performance test between the device it runs on and a specified web server.

## Features

The script performs the following tests:

1. File Download Test: Downloads various generated files of different types and sizes using `wget` and `curl`.
2. Network Latency Test: Tests network latency using `ping`.
3. Path Analysis Test: Performs a path analysis test using `traceroute`.

## Usage

1. Open the script using a text editor and replace `WEBSERVER_URL` with the URL of the web server you want to test against.

2. Run the script in your terminal:

```bash
bash script.sh
```

3. When prompted, enter the number(s) of the tests you want to run, separated by spaces. Here are the options:

* File Download Test
* Network Latency Test
* Path Analysis Test

4. The script will perform the selected tests and save the results to a file named `results.json`.

## Output

The script outputs the results of the tests in a JSON format. Here's an example of the output structure:

```json
{
    "file_download_test": {
        "file_10KB.txt": {
            "wget_speed": "2048 KB/s",
            "curl_speed": "2048 KB/s"
        },
        // other files...
    },
    "network_latency_test": {
        "average_ping": "20.2 ms"
    },
    "path_analysis_test": {
        "traceroute": "traceroute to example.com (93.184.216.34), 30 hops max, 60 byte packets..."
    }
}
```
