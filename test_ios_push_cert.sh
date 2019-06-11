#!/bin/bash

function usage() { 
	echo 'uasge :';
	echo $0' [-d] {cert_path}';
	echo "  -d        : Test sandbox(develop env)";
	echo "  cert_path : Path of cert for testing";
	echo "";
}

endpoint='gateway.push.apple.com:2195'
cert="$1"

while getopts 'dh' flag; do
	case "${flag}" in
		d) endpoint='gateway.sandbox.push.apple.com:2195'; cert="$2" ;;
		h) usage; exit 1;;
		*) usage; exit 1;;
	esac
done

if [ -z $cert ]; then
	usage; exit 1;
fi

openssl s_client -connect "$endpoint" -cert "$cert"
