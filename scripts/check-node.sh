#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

ROLE="${1:-}"
HOSTNAME_SHORT=$(hostname -s)
HOSTS_FILE="$REPO_ROOT/config/hosts"
WORKERS_FILE="$REPO_ROOT/config/workers"

if [[ -z "$ROLE" ]]; then
  echo "Gunakan: $0 <master|worker>"
  exit 1
fi

EXPECTED_IP=$(awk -v host="$HOSTNAME_SHORT" '$2 == host { print $1 }' "$HOSTS_FILE")
LOCAL_IPS=$(hostname -I 2>/dev/null || true)

if [[ "$ROLE" == "master" && "$HOSTNAME_SHORT" != "master" ]]; then
  echo "Setup master hanya boleh dijalankan di host bernama master."
  exit 1
fi

if [[ "$ROLE" == "worker" ]]; then
  if ! grep -qx "$HOSTNAME_SHORT" "$WORKERS_FILE"; then
    echo "Hostname '$HOSTNAME_SHORT' tidak terdaftar di config/workers."
    exit 1
  fi
fi

if [[ -z "$EXPECTED_IP" ]]; then
  echo "Hostname '$HOSTNAME_SHORT' tidak ditemukan di config/hosts."
  exit 1
fi

if [[ " $LOCAL_IPS " != *" $EXPECTED_IP "* ]]; then
  echo "IP lokal node ini tidak cocok dengan config/hosts."
  echo "Hostname : $HOSTNAME_SHORT"
  echo "IP local  : ${LOCAL_IPS:-tidak terbaca}"
  echo "IP config : $EXPECTED_IP"
  exit 1
fi

echo "Validasi node berhasil: $HOSTNAME_SHORT -> $EXPECTED_IP"
