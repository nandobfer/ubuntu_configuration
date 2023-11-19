#!/bin/bash

# Check if gnome-shell-extension-installer is available
if ! command -v gnome-shell-extension-installer &> /dev/null
then
    echo "gnome-shell-extension-installer not found. Installing it now."

    # Download the installer
    wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"

    # Make it executable
    chmod +x gnome-shell-extension-installer

    # Move it to /usr/bin
    sudo mv gnome-shell-extension-installer /usr/bin/
fi

# Define the list of extension IDs
extension_ids=(5721 5393 3843 1762 1193 4630 3010 5748)

gsettings set org.gnome.shell disable-extension-version-validation "true"

# Loop through each ID and run the installer command
for id in "${extension_ids[@]}"; do
    gnome-shell-extension-installer "$id"
done

