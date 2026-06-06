# --- 1. INSTANT PROMPT (Must be at the very top) ---
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- 2. OH-MY-ZSH CONFIG ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Update behavior
zstyle ':omz:update' mode auto

# plugins: 
# - git: standard git aliases
# - zsh-autosuggestions: the "ghost text" based on history
# - fzf-tab: REPLACES standard tab completion with a fuzzy finder (The "Pro" feature)
# - zsh-syntax-highlighting: MUST be last. Colors commands red/green.
plugins=(
    git 
    kubectl 
    zsh-autosuggestions 
    fzf-tab 
    zsh-syntax-highlighting
)

# Source OMZ
source $ZSH/oh-my-zsh.sh

# --- 3. "PRO" COMPLETION SETTINGS (FZF-TAB) ---

# Disable the default OMZ ls colors in favor of fzf-tab specific ones
zstyle ':completion:*:*' list-colors "${(s.:.)LS_COLORS}"

# Use fzf-tab for completion (The magic part)
# This creates a preview window when you tab-complete files or directories
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__git_checkout:*' fzf-preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $word'
zstyle ':fzf-tab:*' switch-group ',' '.' # Use comma and dot to switch groups in completion

# Autosuggestions configuration
# Suggest from history first, but only matches.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# --- 4. HISTORY MANAGEMENT (Fixes "Weird Suggestions") ---
# This makes your history smart. It ignores duplicates and doesn't save failed commands.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write timestamps to history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first when trimming history
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found
setopt HIST_IGNORE_SPACE         # Don't record lines starting with a space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file
setopt SHARE_HISTORY             # Share history between all sessions

# --- 5. KEYBINDINGS ---
# Initialize FZF keybindings (Ctrl+R for history, Ctrl+T for files)
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# Use vim keys in command line (optional, if you like Vi mode, uncomment below)
bindkey -v 

# --- 6. ENVIRONMENT & PATHS ---
export EDITOR='nvim'
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.npm-global/bin:${KREW_ROOT:-$HOME/.krew}/bin:$HOME/.local/go/bin:$PATH"
export PATH="$HOME/.scripts:$PATH"

# Initialize tools
eval "$(zoxide init zsh)" # Replaces 'cd' with smarter navigation

# Import Colors (wal)
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh

# --- 7. ALIASES ---

# Navigation 
alias cdc="cd && clear"
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias c="clear"
alias j="z" 

# Common directories

alias docs="cd ~/Documents"
alias idocs="cd OneDrive/Documents/DocsImportantes"
alias down="cd ~/Downloads"
alias config="cd ~/.config"
alias hypr="cd ~/.config/hypr"
alias dm="cd OneDrive/Desktop/ETH/1S/DiskMath/"
alias and="cd OneDrive/Desktop/ETH/1S/AnD/"
alias eprog="cd OneDrive/Desktop/ETH/1S/Eprog/"
alias epprog="cd programming/IdeaProjects/gduarte/"
alias linalg="cd OneDrive/Desktop/ETH/1S/LinAlg/"
alias lice="cd OneDrive/Desktop/lice"
alias ideas="cd Documents/ideas" 
alias gith="cd /home/gabriel/programming/gith"
alias vis="cd /home/gabriel/programming/vis/"

# Replacements (Modern Tools)
# Note: 'eza' is the maintained version of 'exa'
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first --git"
alias la="eza -la --icons --group-directories-first --git"
alias lt="eza --tree --icons --level=2"
alias cat="bat"
alias v="nvim"

# Pacman / Arch
alias install="sudo pacman -S"
alias remove="sudo pacman -Rs"
alias search="pacman -Ss"
alias update="sudo pacman -Syu"
alias cleanup="sudo pacman -Rns \$(pacman -Qtdq)"
alias yays="yay -S"

# Git
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"
alias gco="git checkout"
alias gsw="git switch"
alias gswc="git switch -c"
alias grom="git fetch origin && git rebase origin/main"
alias gpf="git push --force-with-lease"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias grv="git remote -v"
alias gst="git stash"
alias gsta="git stash apply"
alias gstd="git stash drop"
alias gcl="git clone"
alias gb="git branch"
alias gba="git branch -a"

# Hyprland / Configs
alias hyprc="$EDITOR ~/.config/hypr/hyprland.conf"
alias zshc="$EDITOR ~/.zshrc && source ~/.zshrc"
alias hreload="hyprctl reload"

# System
alias reboot="systemctl reboot"
alias shutdown="systemctl poweroff"

# Utils
alias extract='dtrx'
alias ip="ip -c"
alias open="xdg-open"
alias kiri="kiroku"
alias homelab="ssh gabriel@100.65.145.50"

# Clipboard History
alias cl="cliphist list | fzf | cliphist decode | wl-copy"

# global 
alias -g G='| grep'
alias -g L='| less'
alias -g C='| wc -l'  # Count lines
alias -g N='> /dev/null 2>&1' # Silence output

# Text files -> Open in nvim
alias -s {md,txt,json,toml,yaml,yml,ini,conf,zsh}=nvim

# Images/Documents -> Open in default viewer (xdg-open)
alias -s {png,jpg,jpeg,gif,pdf,mp4,mkv}=xdg-open

# audio
alias audio='wpctl'

# Zellij (Auto-attach or Create)
alias zlj='zellij attach --index 0 || zellij'

# conect to headphones
alias headphones='wpctl set-default $(wpctl status | sed -n "/Sinks:/,/Sources:/p" | grep "Nothing Ear" | grep -Eo "[0-9]+" | head -n 1)'

# clean logs 
alias cleanroot='sudo pacman -Scc && sudo journalctl --vacuum-size=100M && sudo timeshift --check'

# --- 8. FUNCTIONS ---

# Search text in files and display results in Bat
fsearch() {
    rg --line-number --no-heading --color=always "$1" | \
    fzf --ansi --delimiter : --preview "bat --style=numbers --color=always --highlight-line {2} {1}"
}

# Refresh mrconfig automatically
function mr-refresh() {
    rm -f ~/.mrconfig
    # We use ( ) to run this in a subshell so we don't change your current directory
    (cd ~/programming/gith && find . -mindepth 1 -maxdepth 1 -type d -exec mr register {} \;)
    echo "✅ mr configuration refreshed!"
}

# magic-enter
magic-enter () {
  if [[ -z $BUFFER ]]; then
    zle -I
    eza --icons --group-directories-first
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo ""
        git status -sb
        echo ""
        echo ""
    fi
    zle redisplay
  else
    zle accept-line
  fi
}

zle -N magic-enter
bindkey "^M" magic-enter

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# fshow - git commit browser
alias fshow="git log --graph --color=always \
    --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' | \
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
    --bind 'ctrl-m:execute:
                (grep -o \"[a-f0-9]\{7\}\" | head -1 |
                xargs -I % sh -c \"git show --color=always %\") <<FZF-EOF
                {}
FZF-EOF'"

# Extract anything 
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Fuzzy find and open in nvim
vf() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')
  [ -n "$file" ] && nvim "$file"
}

# Create directory and enter it
mkcd() {
    mkdir -p "$1" && cd "$1"
}


# Run any file by extension
run() {
    if [[ -z "$1" ]]; then
        echo "Usage: run <file>"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "File not found: $1"
        return 1
    fi
    local ext="${1##*.}"
    case "$ext" in
        py)           python "$1" ;;
        js)           node "$1" ;;
        ts)           bun "$1" ;;
        java)         javac "$1" && java "${1%.java}" ;;
        c)            gcc -o "/tmp/${1%.c}" "$1" && "/tmp/${1%.c}" ;;
        cpp|cc)       g++ -o "/tmp/${1%.*}" "$1" && "/tmp/${1%.*}" ;;
        rs)           rustc -o "/tmp/${1%.rs}" "$1" && "/tmp/${1%.rs}" ;;
        go)           go run "$1" ;;
        rb)           ruby "$1" ;;
        sh|bash)      bash "$1" ;;
        zsh)          zsh "$1" ;;
        lua)          lua "$1" ;;
        php)          php "$1" ;;
        pl)           perl "$1" ;;
        r|R)          Rscript "$1" ;;
        ex|exs)       elixir "$1" ;;
        hs)           runhaskell "$1" ;;
        swift)        swift "$1" ;;
        kt)           kotlinc "$1" -include-runtime -d /tmp/out.jar && java -jar /tmp/out.jar ;;
        *)            echo "Unknown extension: .$ext" ; return 1 ;;
    esac
}

# Clone a repo AND refresh mr automatically
function gclone() {
    # 1. Go to your git folder
    cd ~/programming/gith || return
    
    # 2. Clone the repo (passing whatever argument you typed)
    gh repo clone "$1"
    
    # 3. Refresh mr (using the function we made earlier)
    # Note: This assumes you added the mr-refresh function from my previous reply
    mr-refresh
    
    echo "🚀 Repo cloned and registered!"
}

# System Maintenance 
sysmaintain() {
    echo -e "\n\033[1;34m[1/4] 📦 Updating System...\033[0m"
    yay -Syu # yay handles both repo and AUR updates

    echo -e "\n\033[1;34m[2/4] 🧹 Cleaning Orphans & Cache...\033[0m"
    if [[ -n $(pacman -Qtdq) ]]; then
        sudo pacman -Rns $(pacman -Qtdq)
    fi
    sudo paccache -rk2

    echo -e "\n\033[1;34m[3/4] 🚑 Checking Errors...\033[0m"
    systemctl --failed

    echo -e "\n\033[1;32m✅ Maintenance Complete.\033[0m"
}

# --- 9. SSH AGENT  ---
export SSH_ASKPASS=/usr/bin/qt4-ssh-askpass
AGENT_ENV_FILE="${HOME}/.ssh/ssh-agent-env"

if [ -f "$AGENT_ENV_FILE" ]; then
    source "$AGENT_ENV_FILE" > /dev/null 2>&1
    if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
        rm -f "$AGENT_ENV_FILE"
        unset SSH_AGENT_PID
    fi
fi

if [ -z "$SSH_AGENT_PID" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    echo "SSH_AGENT_PID=$SSH_AGENT_PID" > "$AGENT_ENV_FILE"
    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> "$AGENT_ENV_FILE"
fi

# --- 10. P10K CONFIG ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# navi
eval "$(navi widget zsh)"

# man 
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# direnev
eval "$(direnv hook zsh)"

# exports
export PATH="$HOME/.cargo/bin:$PATH"

[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets

export GROFF_NO_SGR=1
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
export KUBECONFIG=~/.kube/config-k3s

# bun completions
[ -s "/home/gabriel/.bun/_bun" ] && source "/home/gabriel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# Source all configuration snippets from zshrc.d
if [ -d ~/.config/zshrc.d ]; then
  for f in ~/.config/zshrc.d/*.{sh,zsh}(N); do
    source "$f"
  done
fi

# Added by Antigravity CLI installer
export PATH="/home/gabriel/.local/bin:$PATH"
