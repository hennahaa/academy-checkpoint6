#!/bin/bash

KEY_RING="KEY-RING-ID"
KEY="KEY-ID"
BUCKET="BUCKET-ID"
LOCATION="LOCATION-ID" #europe-north1

if [ ! -f root.log ]; then
  touch root.log
fi

grep -i 'root' /var/log/syslog >> root.log

gcloud kms encrypt \
    --key $KEY \
    --keyring $KEY_RING \
    --location $LOCATION \
    --plaintext-file root.log \
    --ciphertext-file root.log

gsutil cp root.log gs://$BUCKET
