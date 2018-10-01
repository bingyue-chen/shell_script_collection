#!/bin/bash
openssl pkcs12 -in $1 -out $2 -clcerts -nokeys
openssl pkcs12 -in $1 -out $3 -nocerts
cat $2 $3 > $4