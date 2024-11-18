#!/bin/bash

# Check if a URL was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL="$1"

# Fetch the HTML content using curl
echo "Fetching HTML content from $URL..."
HTML_CONTENT=$(curl -s "$URL")

# Extract all URLs (http, https, ftp, etc.) from the HTML content
# Match <a href>, <img src>, <script src>, <link href>, etc.
echo "Extracted URLs from the page:"

# Using a regex to capture various protocols like http, https, ftp, and others
echo "$HTML_CONTENT" | grep -Eo '(http|https|ftp|ftps|file)://[a-zA-Z0-9./?&=_%+-]*' | sort -u > urls.txt

# Display extracted URLs
cat urls.txt

# Prompt user to download these files
echo
read -p "Would you like to download these files? (y/n) " ANSWER
if [[ "$ANSWER" =~ ^[Yy]$ ]]; then
    # Create a directory for downloads if it doesn't exist
    mkdir -p downloaded_files
    # Download each file using curl
    while read -r FILE_URL; do
        echo "Downloading $FILE_URL..."
        curl -O "$FILE_URL" -P downloaded_files/
    done < urls.txt
    echo "Downloaded files saved in the 'downloaded_files/' directory."
else
    echo "Download canceled."
fi
