#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 PAYLOAD_FILE"
    exit 1
fi

# Append binary data.
cp install.sh.in install.sh
echo "PAYLOAD:" >> install.sh
cat $1          >> install.sh

