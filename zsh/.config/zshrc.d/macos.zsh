# macOS compatibility layer; shared zshrc remains the source of truth.
if [[ "$(uname -s)" == Darwin ]]; then
  export PATH="/opt/local/bin:/usr/local/bin:/opt/homebrew/bin:$HOME/.local/share/pi-node/node-v22.23.2-darwin-x64/bin:$PATH"
  alias install='brew install'
  alias remove='brew uninstall'
  alias search='brew search'
  alias update='brew update && brew upgrade'
  alias cleanup='brew cleanup'
  alias open='open'
  alias pbcopy='pbcopy'
  alias pbpaste='pbpaste'
  alias cl='pbpaste | fzf | pbcopy'
  alias reboot='sudo shutdown -r now'
  alias shutdown='sudo shutdown -h now'
  alias audio='osascript -e "set volume output muted not (output muted of (get volume settings))"'
  alias screenshot='screencapture -i -c'
  alias xcode='open -a Xcode'
  export SSH_ASKPASS=""
  export PUPPETEER_EXECUTABLE_PATH="$(command -v google-chrome || command -v chromium || true)"
  export HOMEBREW_NO_ENV_HINTS=1
fi
