#!/usr/bin/env sh

tarball=$1

if [[ -z $tarball ]]; then
    echo "no tarball here"
    exit 1
fi

set -euo pipefail

TOPDIR=$(pwd)
rm -rf wallet-temp
mkdir -p wallet-temp
tar -xaf $tarball -C wallet-temp --strip-components=1
pushd wallet-temp
cargo vendor-filterer \
      --platform=x86_64-unknown-linux-gnu \
      --platform=aarch64-unknown-linux-gnu \
      --format=tar.gz \
      $TOPDIR/wallet-vendor.tar.gz
pushd bindgen/cpp
cargo vendor-filterer \
      --platform=x86_64-unknown-linux-gnu \
      --platform=aarch64-unknown-linux-gnu \
      --format=tar.gz \
      $TOPDIR/wallet-bindgen-vendor.tar.gz
popd
popd
rm -rf wallet-temp
