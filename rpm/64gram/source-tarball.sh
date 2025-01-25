#!/usr/bin/env sh

name=64gram-desktop
tag=$1

if [[ -z $tag ]]; then
    echo "This script requires the tag as an argument."
    exit 1
fi

version=${tag#v}
echo "Using version: $version"

rm -rf "$name-$version"
git -c advice.detachedHead=false clone --recurse-submodules --branch "$tag" --depth 1 https://github.com/TDesktop-x64/tdesktop "$name-$version"

# More reproducible!
TARFLAGS=(
  --exclude .git
  --sort=name
  --format=posix
  --pax-option=delete=atime,delete=ctime
  --clamp-mtime
  --mtime='1970-01-01 00:00:00 UTC'
  --numeric-owner
  --owner=0
  --group=0
  --mode=go+u,go-w
)

tar "${TARFLAGS[@]}" -czvf "$name-$version.tar.gz" "$name-$version"

rm -rf "$name-$version"
