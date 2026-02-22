# ----------------------------
# Antidote Plugin Manager
# ----------------------------

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# ----------------------------
# Zsh Completion
# ----------------------------
autoload -Uz compinit
compinit

# ----------------------------
# Aliases
# ----------------------------

alias ll="ls -lah"
alias gst="git status"
alias gpl="git pull"
alias start-openwebui='docker run -d -p 3000:8080 -v ~/llm/ollama_webui_data:/data -e OLLAMA_BASE_URL=http://host.docker.internal:11434 -e WEBUI_AUTH=False --name open-webui --restart always ghcr.io/open-webui/open-webui:main'

# ----------------------------
# Starship Prompt
# ----------------------------

eval "$(starship init zsh)"

# ----------------------------
# Pyenv Setup
# ----------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# ----------------------------
# Load local overrides (never committed)
# ----------------------------
if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi
