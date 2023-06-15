#!/usr/bin/env bash

# Script to determine geolocation by IP or DNS name

# Check if the package is installed
if ! dpkg -s jq &>/dev/null; then
    echo "The jq package is not installed, performing installation..."

    # Install the package
    sudo apt install jq -y

    # Check the installation result
    if dpkg -s jq &>/dev/null; then
        echo "The jq package has been successfully installed."
    else
        echo "Failed to install the jq package."
    fi

fi

IP_SERVICE='http://ip-api.com'

curl -s ${IP_SERVICE}/json/$1 | jq -r
