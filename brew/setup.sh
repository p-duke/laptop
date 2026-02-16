#!/usr/bin/env bash

set -e

# Install Homebrew if not installed
if ! command -v brew &> /dev/null
then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is available in PATH (Apple Silicon)
if [[ -d "/opt/homebrew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install everything from Brewfile
brew bundle --file="~/laptop/brew/Brewfile"
