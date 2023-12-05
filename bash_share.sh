#!/bin/bash

#route | grep '^default' | grep -o '[^ ]*$'
#echo "LA" | nc -u 192.168.63.255 45454

if [[ $# -eq 0 ]]; then
	echo "Usage: bash_share.sh"
	exit 0
fi

if [[ $1 == "rc" ]]; then
	echo "read"
else
	echo "send $1"
fi

