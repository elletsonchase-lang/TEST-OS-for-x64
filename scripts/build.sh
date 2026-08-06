#!/usr/bin/env bash

set -e

echo "========================================"
echo "Building Phoenix OS Live USB"
echo "No installer is included."
echo "Phoenix OS runs directly from a USB."
echo "========================================"

# Delete old build files so every build starts clean.
rm -rf build
rm -rf output

# Create fresh build and output folders.
mkdir -p build
mkdir -p output

# Enter the build folder.
cd build

echo "Configuring the Ubuntu-based live system..."

# Configure a bootable 64-bit Ubuntu live ISO.
lb config \
    --mode ubuntu \
    --distribution noble \
    --architectures amd64 \
    --binary-images iso-hybrid \
    --bootloader syslinux \
    --archive-areas "main restricted universe multiverse" \
    --bootappend-live "boot=live components quiet splash" \
    --iso-application "Phoenix OS Live" \
    --iso-publisher "Phoenix OS Project" \
    --iso-volume "PHOENIX_OS"

# Create the package-list folder.
mkdir -p config/package-lists

# Copy the Phoenix OS package list into live-build.
cp \
    ../config/package-lists/phoenix.list.chroot \
    config/package-lists/phoenix.list.chroot

echo "========================================"
echo "Starting Phoenix OS ISO build..."
echo "========================================"

# Build the live USB ISO.
lb build

# Find the ISO created by live-build.
ISO_FILE="$(find . -maxdepth 1 -type f -name '*.iso' | head -n 1)"

# Stop with an error if no ISO was created.
if [ -z "$ISO_FILE" ]; then
    echo "========================================"
    echo "ERROR: No ISO file was created."
    echo "========================================"
    exit 1
fi

# Copy the finished ISO to the output folder.
cp "$ISO_FILE" ../output/Phoenix-OS-Live-amd64.iso

echo "========================================"
echo "PHOENIX OS BUILD SUCCESSFUL!"
echo "========================================"

echo "Finished ISO:"
ls -lh ../output/Phoenix-OS-Live-amd64.iso

echo "========================================"
echo "Phoenix OS is a live USB operating system."
echo "No hard-drive installer was added."
echo "========================================"
