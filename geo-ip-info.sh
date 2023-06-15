#!/usr/bin/env bash
#
# Script Name: geo-ip-info
# Version: 1.0
# Description: Script to determine geolocation by IP or DNS name
# Author: Zeroberto86
# Created Date: 15.06.2023
# License: GNU GPL
#

# set -x

# Check if the user has sudo privileges
if ! sudo -v &>/dev/null; then
  echo "You do not have sudo privileges."
  exit 0
fi

function lowercase(){
    local TEXT="$1"
    echo $TEXT | tr '[:upper:]' '[:lower:]' 
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to install jq on Debian/Ubuntu
install_jq_debian() {
    sudo apt-get update
    sudo apt-get install -y jq
}

# Function to install jq on Fedora
install_jq_fedora() {
    sudo dnf install -y jq
}

# Function to install jq on CentOS
install_jq_centos() {
    sudo yum install -y epel-release
    sudo yum install -y jq
}

# Function to install jq on Arch Linux
install_jq_arch() {
    sudo pacman -Sy --noconfirm jq
}

# Check if jq is already installed
if ! command_exists jq; then

# Determine the Linux distribution
if command_exists lsb_release; then
    distro=$(lowercase $(lsb_release -si))
else
    distro=$(cat /etc/os-release | grep -oP '(?<=^ID=).+' | tr -d '"')
fi

# Install jq based on the Linux distribution
case "$distro" in
    debian*|ubuntu*|kali*)
        install_jq_debian
        ;;
    fedora*)
        install_jq_fedora
        ;;
    centos*)
        install_jq_centos
        ;;
    arch*)
        install_jq_arch
        ;;
    *)
        echo "Unsupported distribution: $distro. Cannot install jq."
        exit 1
        ;;
esac

# Check if jq installation was successful
if command_exists jq; then
    echo "jq has been successfully installed."
else
    echo "Failed to install jq."
fi

fi 

IP_SERVICE='http://ip-api.com'

curl -s ${IP_SERVICE}/json/$1 | jq -r
