#!/bin/bash

# replace these with your server details
WEBSERVER_URL="http://127.0.0.1:5500"

# file size in KB for the generated files
FILE_SIZES=(1000 10000 100000 1000000)

# file types to test
FILE_TYPES=("txt" "jpg" "mp4" "pdf")

# function to generate random file of specified size and type
generate_file() {
    local file_size="$1"
    local file_type="$2"

    local file_name="file_${file_size}KB.${file_type}"
    dd if=/dev/urandom of="$file_name" bs=1024 count="$file_size" > /dev/null 2>&1

    echo "$file_name"
}

# function to test file download with wget and curl
test_file_download() {
    local file_name="$1"
    
    # download file with wget and capture download speed
    wget_speed=$(wget -q --show-progress "$WEBSERVER_URL/$file_name" 2>&1 | tail -2 | head -1 | awk '{print $3 " " $4}')

    # download file with curl and capture download speed
    curl_speed=$(curl -s -O "$WEBSERVER_URL/$file_name" -w '%{speed_download}' -o /dev/null)

    # json output
    echo "\"$file_name\": {\"wget_speed\": \"$wget_speed\", \"curl_speed\": \"$curl_speed\"}"
}

# function to test network latency with ping
test_latency() {
    # capture average ping time
    avg_ping=$(ping -c 4 "$(echo "$WEBSERVER_URL" | awk -F/ '{print $3}')" | tail -1| awk '{print $4}' | cut -d '/' -f 2)

    # json output
    echo "\"average_ping\": \"$avg_ping\""
}

# function to test path analysis with traceroute
test_traceroute() {
    # capture traceroute output
    traceroute_output=$(traceroute "$(echo "$WEBSERVER_URL" | awk -F/ '{print $3}')")

    # json output
    echo "\"traceroute\": \"$traceroute_output\""
}

echo "Please enter the number(s) of the tests you want to run, separated by spaces:"
echo "1) File Download Test"
echo "2) Network Latency Test"
echo "3) Path Analysis Test"
read -a CHOICES

RESULT="{"


for CHOICE in "${CHOICES[@]}"
do
    case $CHOICE in
        1)
            RESULT="$RESULT\"file_download_test\": {"
            for file_size in "${FILE_SIZES[@]}"; do
                for file_type in "${FILE_TYPES[@]}"; do
                    file_name=$(generate_file "$file_size" "$file_type")
                    echo "Testing file: $file_name"
                    RESULT="$RESULT$(test_file_download "$file_name"),"
                    rm -f "$file_name"
                done
            done
            RESULT=$(echo "$RESULT" | sed 's/,$//')
            RESULT="$RESULT},"
            ;;
        2)
            RESULT="$RESULT\"network_latency_test\": {$(test_latency)},"
            ;;
        3)
            RESULT="$RESULT\"path_analysis_test\": {$(test_traceroute)},"
            ;;
    esac
done

# Remove trailing comma and close the JSON
RESULT=$(echo "$RESULT" | sed 's/,$//')
RESULT="$RESULT}"
echo $RESULT
echo $RESULT > results.json