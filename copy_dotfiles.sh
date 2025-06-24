#!/bin/bash

# Script to copy dotfiles to /root/ directory
# This script copies .bashrc, .bashrc_addon, .zshrc, and .config to /root/

echo "Copying dotfiles to /root/ directory..."

# Create backup of existing files if they exist
if [ -f /root/.bashrc ]; then
    echo "Creating backup of existing .bashrc..."
    cp /root/.bashrc /root/.bashrc.backup
fi

if [ -f /root/.bashrc_addon ]; then
    echo "Creating backup of existing .bashrc_addon..."
    cp /root/.bashrc_addon /root/.bashrc_addon.backup
fi

if [ -f /root/.zshrc ]; then
    echo "Creating backup of existing .zshrc..."
    cp /root/.zshrc /root/.zshrc.backup
fi

if [ -d /root/.config ]; then
    echo "Creating backup of existing .config directory..."
    cp -r /root/.config /root/.config.backup
fi

# Copy the dotfiles to /root/
echo "Copying .bashrc..."
cp .bashrc /root/

echo "Copying .bashrc_addon..."
cp .bashrc_addon /root/

echo "Copying .zshrc..."
cp .zshrc /root/

echo "Copying .config directory..."
cp -r .config /root/

echo "Done! Dotfiles have been copied to /root/ directory."
echo "Backups of existing files (if any) have been created with .backup extension."
