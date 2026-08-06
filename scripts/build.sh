#!/usr/bin/env bash

set -e

echo "========================================"
echo "Building Phoenix OS Live USB ISO"
echo "No installer will be included."
echo "========================================"

# Start with a completely clean build.
rm -rf build
rm -rf output

mkdir -p build
mkdir -p output

cd build

# Create a plain Debian live-build configuration.
# Ubuntu packages will be used inside the live system.
lb config \
    --mode ubuntu \
    --distribution noble \
    --architectures amd64 \
    --binary-images iso-hybrid \
    --bootloader grub-efi \
    --debian-installer none \
    --archive-areas "main restricted universe multiverse" \
    --bootappend-live "boot=live components quiet splash" \
    --iso-application "Phoenix OS Live" \
    --iso-publisher "Phoenix OS Project" \
    --iso-volume "PHOENIX_OS_LIVE"

# Copy our package list into the generated live-build config.
mkdir -p config/package-lists

cp \
    ../config/package-lists/phoenix.list.chroot \
    config/package-lists/phoenix.list.chroot

echo "========================================"
echo "Starting live ISO build..."
echo "========================================"

lb build

ISO_FILE="$(find . -maxdepth 1 -type f -name '*.iso' | head -n 1)"

if [ -z "$ISO_FILE" ]; then
    echo "ERROR: The build finished without creating an ISO."
    exit 1
fi

cp "$ISO_FILE" ../output/Phoenix-OS-Live-amd64.iso

echo "========================================"
echo "Phoenix OS Live build finished!"
echo "========================================"

ls -lh ../output/
