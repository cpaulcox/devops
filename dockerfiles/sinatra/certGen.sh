#!/bin/bash

# -nodes = No DES no private key passphrase
# DNS name in the CN is depracated. Use subject alt name

# from https://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl

openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout example.key -out example.crt -subj "/CN=example.com" \
  -addext "subjectAltName=DNS:example.com,DNS:example.net,IP:10.0.0.1"

