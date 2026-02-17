# Laptop Setup

## Setup Wezterm
1. Create wezterm config directory
`mkdir -p ~/.config/wezterm`

1. Symlink wezterm.lua
`ln -s ~/laptop/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua`

## Setup Pyenv
Install a version
```bash
pyenv install 3.11.7
pyenv global 3.11.7
```
## Software Probably Needed
- [Docker](https://www.docker.com/products/docker-desktop/)
- [Open-WebUI](https://github.com/open-webui/open-webui)

## Working with Open-WebUI
Create a directory for persistent chats
`mkdir -p ~/ollama_webui_data`

Run the image (`start-openwebui`)
```
docker run -d \
  -p 3000:8080 \
  -v ~/ollama_webui_data:/data \
  -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

## Shell
- [Starship](https://starship.rs/)
- [Antidote](https://antidote.sh/)
- [Nerd Fonts](https://www.nerdfonts.com/)

### Link .zshrc
`ln -s ~/laptop/shell/.zshrc ~/.zshrc`

### Link Starship
`mkdir -p ~/.config`
`ln -s ~/laptop/starship/starship.toml ~/.config/starship.toml`

### Link Antidote
1. Pull the latest from the submodule in ~/laptop/
`git submodule update --init --recursive`

1. `ln -s ~/laptop/antidote ~/.antidote`
1. `ln -s ~/laptop/shell/.zsh_plugins.txt ~/.zsh_plugins.txt`

Install NerdFont
_Included in the brewfile_

Create a .zshrc.local to extend
`touch ~/.zshrc.local`

