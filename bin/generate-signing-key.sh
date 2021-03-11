#!/usr/bin/env bash

main() {
  apt update -y
  apt install -y gnupg1 pwgen
  
  mkdir -p /data
  PASSPHRASE="$(pwgen -cnys 64 1 | tr -d '\n' | base64 -w0 | tee /data/passphrase.txt | base64 -d)"
  echo | cat | gpg1 --batch --gen-key <<EOF
  Key-Type: rsa
  Key-Length: 4096
  Key-Usage: sign
  Passphrase: ${PASSPHRASE}
  Name-Real: Chart Releaser
EOF
  base64 -w0 /root/.gnupg/secring.gpg > /data/secring.gpg
  echo "=============== Github Actions Secrets  ================="
  echo "GPG_PASSPHRASE_BASE64: $(cat /data/passphrase.txt)"
  echo "GPG_KEYRING_BASE64: $(cat /data/secring.gpg)"
  echo "========================================================="
  echo "================= Public Signing Key ===================="
  gpg1 --export --armor
  echo "========================================================="
}

(declare -f main; echo main) | base64 | docker run --rm -i ubuntu:20.04 bash -c 'base64 -d | bash -s'
