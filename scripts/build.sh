#!/bin/bash

set -e

echo "================================="
echo "Building Phoenix OS"
echo "================================="

rm -rf build
mkdir -p build
mkdir -p output

cd build

lb config \
    --distribution noble \
    --architectures amd64 \
    --binary-images iso-hybrid \
    --archive-areas "main universe multiverse restricted" \
    --bootappend-live "boot=live components quiet splash" \
    --debian-installer false \
    --apt-indices false \
    --iso-application "Phoenix OS" \
    --iso-publisher "Phoenix OS Project" \
    --iso-volume "PHOENIX_OS"

cp -r ../config/* config/

echo "Starting ISO build..."

lb build

ISO_FILE=$(find . -maxdepth 1 -name "*.iso" | head -n 1)

if [ -z "$ISO_FILE" ]; then
    echo "ERROR: No ISO was created."
    exit 1
fi

cp "$ISO_FILE" ../output/Phoenix-OS-amd64.iso

echo "================================="
echo "Phoenix OS build complete!"
echo "ISO:"
echo "output/Phoenix-OS-amd64.iso"
echo "================================="
