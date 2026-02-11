#!/usr/bin/env bash
set -euo pipefail

DEST="."
BASE_URL="https://repo.zabbix.com/zabbix"

mkdir -p "$DEST"

declare -A MATRIX=(
  # Debian
  [Debian:13]=7.4
  [Debian:12]=7.2
  [Debian:11]=7.2
  [Debian:10]=7.0
  [Debian:9]=6.0

  # Ubuntu
  [Ubuntu:22.04]=7.2
  [Ubuntu:20.04]=7.2
  [Ubuntu:18.04]=7.0
  [Ubuntu:16.04]=7.0

  # RedHat / CentOS
  [RedHat:8]=7.2
  [RedHat:7]=7.2
  [RedHat:6]=7.0

  # SLES
  [SLES:15]=7.2
)

fetch() {
  local url="$1"
  local file="$2"

  if [[ -f "$DEST/$file" ]]; then
    echo "OK  exists $file"
    return
  fi

  echo "GET $file"
  echo curl -fL "$url" -o "$DEST/$file"
  curl -fL "$url" -o "$DEST/$file"
}

is_old_layout() {
  [[ "$1" == "6.0" || "$1" == "7.0" ]]
}

for key in "${!MATRIX[@]}"; do
  os="${key%%:*}"
  rel="${key##*:}"
  ver="${MATRIX[$key]}"

  case "$os" in
    Debian|Ubuntu)
      os_lc=$(echo "$os" | tr 'A-Z' 'a-z')
      if is_old_layout "$ver"; then
        pkg="zabbix-release_latest_${ver}+${os_lc}${rel}_all.deb"
        url="$BASE_URL/${ver}/${os_lc}/pool/main/z/zabbix-release/${pkg}"
        fetch "$url" "$pkg"
      else
        pkg="zabbix-release_latest_${ver}+${os_lc}${rel}_all.deb"
        url="$BASE_URL/${ver}/release/${os_lc}/pool/main/z/zabbix-release/${pkg}"
        fetch "$url" "$pkg"
      fi
      ;;

    RedHat)
      if is_old_layout "$ver"; then
        # 6.0 / 7.0 — старый layout
        pkg="zabbix-release-latest-${ver}.el${rel}.noarch.rpm"
        url="$BASE_URL/${ver}/rhel/${rel}/x86_64/${pkg}"
      else
        # 7.2+ — новый layout
        pkg="zabbix-release-latest-${ver}.el${rel}.noarch.rpm"
        url="$BASE_URL/${ver}/release/rhel/${rel}/noarch/${pkg}"
      fi
      fetch "$url" "$pkg"
      ;;

    SLES)
      pkg="zabbix-release-latest-${ver}.sles${rel}.noarch.rpm"
      url="$BASE_URL/${ver}/release/sles/${rel}/noarch/${pkg}"
      fetch "$url" "$pkg"
      ;;
  esac
done

curl https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX-B5333005 > RPM-GPG-KEY-ZABBIX-B5333005

echo "DONE"