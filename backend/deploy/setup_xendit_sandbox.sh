#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "File .env tidak ditemukan di $ROOT_DIR"
  exit 1
fi

echo "Setup Xendit Sandbox"
echo "- Key tidak akan ditampilkan di layar"
echo "- Akan update .env: XENDIT_API_KEY dan PAYOUT_GATEWAY"

read -r -s -p "Masukkan XENDIT Sandbox API Key (xnd_development_...): " XENDIT_KEY
echo

if [[ -z "$XENDIT_KEY" ]]; then
  echo "XENDIT_API_KEY wajib diisi"
  exit 1
fi

if [[ "$XENDIT_KEY" == xnd_public_* ]]; then
  echo "Key yang dimasukkan adalah public key. Untuk request server-to-server Xendit, kamu harus memakai secret key sandbox (biasanya berawalan xnd_development_ atau format secret key yang ditampilkan di dashboard)."
  exit 1
fi

if [[ "$XENDIT_KEY" != xnd_development_* ]]; then
  echo "Peringatan: key tidak berawalan xnd_development_. Lanjut jika memang benar."
fi

upsert_env() {
  local key="$1"
  local value="$2"

  if grep -qE "^${key}=" "$ENV_FILE"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
  else
    echo "${key}=${value}" >> "$ENV_FILE"
  fi
}

upsert_env "XENDIT_API_KEY" "$XENDIT_KEY"
upsert_env "PAYOUT_GATEWAY" "xendit"

echo "Catatan: skrip ini hanya menulis ke .env supaya tidak ada key Windows user env yang menimpa konfigurasi lokal."
echo "Jika sebelumnya pernah menjalankan setx XENDIT_API_KEY, hapus dulu dari Environment Variables Windows atau tutup semua terminal lalu buka terminal baru."

echo "Menjalankan verifikasi gateway..."
cd "$ROOT_DIR"
export XENDIT_API_KEY="$XENDIT_KEY"
export PAYOUT_GATEWAY="xendit"
php artisan payouts:test-gateway 10000 --to=08123456789

echo "Selesai. Jika masih gagal, kirim output error agar saya lanjutkan debugging."
