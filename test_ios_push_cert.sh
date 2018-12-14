#!/bin/bash
openssl s_client -connect gateway.push.apple.com:2195 -cert $1
