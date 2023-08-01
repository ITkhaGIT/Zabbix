#!/bin/bash
PSK_Identity="PSK-$(hostname)"
PSK=""

# Check the script is being run by root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
        echo 'This installer needs to be run with "bash", not "sh".'
        exit 1
fi

# Генерация PSK
generate_psk() {
    PSK=$(openssl rand -hex 32)
}

generate_psk

echo "PSK Identity: $PSK_Identity"
echo "Generated PSK: $PSK"
