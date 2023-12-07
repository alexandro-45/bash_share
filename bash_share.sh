#!/bin/bash

PORT=45454

print_usage() {
	echo "Usage: bash_share install - install in /usr/bin"
	echo "       bash_share rc - receive file"
	echo "       bash_share <IP> </file/path> - send file"
	exit 0
}

if [[ $# -eq 0 ]]; then
	print_usage
fi

if [[ $1 == "install" ]]; then
	echo "Installing in /usr/bin/"
	sudo cp bash_share /usr/bin/bash_share && \
	sudo chmod 755 /usr/bin/bash_share && \
	echo "Script installed!"
elif [[ $1 == "rc" ]]; then
	echo "Listen for incoming file..."
	filename=$(nc -l -p $PORT)
	echo "Filename: $filename"
	nc -l -p $PORT > $filename
	remote_hash=$(nc -l -p $PORT)
	echo "Remote hash: $remote_hash"
	hash=$(md5sum "$filename" | cut -d ' ' -f1)
	echo "Calculated hash: $hash"
	if [[ "$remote_hash" == "$hash" ]]; then
		echo "File $filename received successful."
	fi
elif [[ $# -eq 2 ]] && [[ $1 =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
	echo "Sending file: $2 to $1"
	name=$(basename $2)
	echo $name | nc $1 $PORT
	sleep 1s
	nc $1 $PORT < $2
	sleep 1s
	echo $(md5sum "$2" | cut -d ' ' -f1) | nc $1 $PORT
else
	print_usage
fi

