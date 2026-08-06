#!/usr/bin/env bash

set -e

echo "========================================"
echo "Building Phoenix OS Live USB"
echo "This OS will run from a USB."
echo "No installer is included."
echo "========================================"

# Remove old build files.
rm -rf build
rm -rf output

# Create fresh folders.
mkdir -p build
mkdir -p output

cd build

# Configure the Ubuntu-based live system.
lb config \
    --mode ubuntu \
    --distribution noble \
    --architectures amd64 \
    --binary-images iso-hybrid \
    --bootloader grub-efi \
    --archive-areas "main restricted universe multiverse" \
    --bootappend-live "boot=live components quiet splash" \
    --iso-application "Phoenix OS Live" \
    --iso-publisher "Phoenix OS Project" \
    --iso-volume "PHOENIX_OS"

# Add the Phoenix OS package list.
mkdir -p config/package-lists

cp \
    ../config/package-lists/phoenix.list.chroot \
    config/package-lists/phoenix.list.chroot

echo "========================================"
echo "Building the Phoenix OS ISO..."
echo "========================================"

lb build

# Find the ISO created by live-build.
ISO_FILE="$(find . -maxdepth 1 -type f -name '*.iso' | head -n 1)"

if [ -z "$ISO_FILE" ]; then
    echo "ERROR: No ISO was created."
    exit 1
fi

# Copy the ISO to the GitHub Actions output folder.
cp "$ISO_FILE" ../output/Phoenix-OS-Live-amd64.iso

echo "========================================"
echo "BUILD SUCCESSFUL"
echo "========================================"

ls -lh ../output/
