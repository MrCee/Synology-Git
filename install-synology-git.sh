#!/bin/bash

if ! git --version > /dev/null 2>&1; then
    echo "Git not installed. Adding the SynoCommunity repository..."

    # Add SynoCommunity feed if not present
    if [[ ! -f /usr/syno/etc/packages/feeds ]]; then
        echo "Adding SynoCommunity feed..."
        echo '[{"feed":"https://packages.synocommunity.com/","name":"SynoCommunity"}]' | sudo tee /usr/syno/etc/packages/feeds > /dev/null
        sudo chmod 755 /usr/syno/etc/packages/feeds
        if [[ $? -eq 0 ]]; then
            echo "SynoCommunity feed added successfully."
        else
            echo "Failed to add SynoCommunity feed."
            exit 1
        fi
    fi

    # Append to feeds if SynoCommunity is missing
    if ! sudo grep -q "https://packages.synocommunity.com/" /usr/syno/etc/packages/feeds; then
        echo "Appending SynoCommunity feed..."
        echo '[{"feed":"https://packages.synocommunity.com/","name":"SynoCommunity"}]' | sudo tee -a /usr/syno/etc/packages/feeds > /dev/null
        if [[ $? -eq 0 ]]; then
            echo "SynoCommunity feed appended successfully."
        else
            echo "Failed to append SynoCommunity feed."
            exit 1
        fi
    fi

    # Attempt to install Git using install_from_server
    echo "Attempting to install Git from SynoCommunity..."
    if sudo synopkg install_from_server Git > /dev/null 2>&1; then
        echo "Git has been successfully installed."
    else
        echo "Failed to install Git."
        exit 1
    fi
else
    echo "Git is already installed."
fi

# Verify Installation
if git --version > /dev/null 2>&1; then
    GIT_VERSION=$(git --version)
    echo "Git installation verified."
    echo "$GIT_VERSION"

    # Display warning about the Git version not being the latest
    echo "Note: The installed Git version may not be the latest. This is the SynoCommunity version, which might be outdated."
else
    echo "Git installation could not be verified."
    exit 1
fi

