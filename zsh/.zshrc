# --- 1. COMPLETION SYSTEM (Fast, Cached) ---
setopt EXTENDED_GLOB
fpath=(
    /usr/share/zsh/site-functions
    $HOME/.local/share/zsh/plugins/zsh-completions/src(N)
    $fpath
)

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
else
    compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# Background zcompile .zcompdump for instant loading
{
    if [[ -s "${ZDOTDIR:-$HOME}/.zcompdump" && (! -s "${ZDOTDIR:-$HOME}/.zcompdump.zwc" || "${ZDOTDIR:-$HOME}/.zcompdump" -nt "${ZDOTDIR:-$HOME}/.zcompdump.zwc") ]]; then
        zcompile "${ZDOTDIR:-$HOME}/.zcompdump"
    fi
} &!

# --- 2. PLUGINS (Direct, no OMZ wrapper) ---
# fzf-tab (replaces standard completion menu with fuzzy finder)
for plugin in \
    $HOME/.local/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh \
    $HOME/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.plugin.zsh
do
    if [[ -f "$plugin" ]]; then source "$plugin"; break; fi
done

# Autosuggestions (ghost text based on history)
for plugin in \
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /opt/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    $HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
do
    if [[ -f "$plugin" ]]; then source "$plugin"; break; fi
done

# --- 3. COMPLETION & FZF-TAB SETTINGS ---
zstyle ':completion:*:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__git_checkout:*' fzf-preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $word'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,%cpu,%mem,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
    '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:*' switch-group ',' '.'

# Autosuggestions configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1

# General shell ergonomics
setopt AUTO_CD               # Type folder name directly to cd
setopt INTERACTIVE_COMMENTS  # Allow # comments in interactive shell
setopt NO_BEEP               # No beep on error/completion

# --- 4. HISTORY MANAGEMENT ---
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

# --- 5. KEYBINDINGS & VI MODE ---
bindkey -v
export KEYTIMEOUT=1              # Instant switch to normal mode on Esc
bindkey '^?' backward-delete-char # Backspace works past insert point

# Beam cursor '|' in insert mode, block '█' in normal mode
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[2 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ -z ${KEYMAP} ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select
_fix_cursor() { echo -ne '\e[5 q' }
precmd_functions+=(_fix_cursor)

# Prefix history search with Up / Down
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Initialize FZF keybindings (Ctrl+R for history, Ctrl+T for files)
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
[[ -f /opt/local/share/fzf/shell/key-bindings.zsh ]] && source /opt/local/share/fzf/shell/key-bindings.zsh
[[ -f /opt/local/share/fzf/shell/completion.zsh ]] && source /opt/local/share/fzf/shell/completion.zsh 

# --- 6. ENVIRONMENT & PATHS ---
export EDITOR='nvim'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export GROFF_NO_SGR=1
export KUBECONFIG=~/.kube/config-k3s
export BUN_INSTALL="$HOME/.bun"
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Unique, consolidated PATH
typeset -U path PATH
path=(
    $HOME/.local/bin
    $HOME/bin
    $HOME/.scripts
    $HOME/.cargo/bin
    $HOME/.bun/bin
    $HOME/.jbang/bin
    $HOME/.npm-global/bin
    ${KREW_ROOT:-$HOME/.krew}/bin
    $HOME/.local/go/bin
    $HOME/.local/share/gem/ruby/3.4.0/bin
    /opt/local/bin
    /opt/local/sbin
    $path
)
export PATH

# Secrets
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets

# Initialize tools
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)" # Replaces 'cd' with smarter navigation

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
alias ideas="cd Documents/ideas" 
alias gith="cd $HOME/programming/gith"
alias vis="cd $HOME/programming/vis/"

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
alias gds="git diff --stat"
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
alias gpu="git push -u origin"

# zsh
alias zshc="$EDITOR ~/.zshrc && source ~/.zshrc"

# System
alias reboot="systemctl reboot"
alias shutdown="systemctl poweroff"

# Utils
alias k="kubectl"
alias bitwarden='bitwarden --enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu'
alias extract='dtrx'

# Pi Coding Agent (use -t/--tmux to start inside tmux for side-by-side leaf preview & subagents)
pi() {
    # Only use tmux flow if -t/--tmux is requested, we're in an interactive terminal, and not already inside tmux
    local want_tmux=0
    local -a args=()
    for arg in "$@"; do
        if [[ "$arg" == "-t" || "$arg" == "--tmux" ]]; then
            want_tmux=1
        else
            args+=("$arg")
        fi
    done

    if [[ "$want_tmux" -eq 0 || -n "$TMUX" || ! -t 0 || ! -t 1 ]]; then
        command pi "${args[@]}"
        return
    fi

    local pi_bin="${commands[pi]:-$(whence -p pi 2>/dev/null || which pi 2>/dev/null || echo pi)}"
    local dir_slug="$(basename "$PWD" | tr -cs '[:alnum:]_-' '-' | sed 's/^-//;s/-$//')"
    [[ -z "$dir_slug" ]] && dir_slug="main"
    local sname="pi-${dir_slug}"

    # If this directory's session exists and is detached, reattach to it
    if tmux has-session -t "$sname" 2>/dev/null; then
        local attached
        attached="$(tmux list-sessions -F '#{session_name} #{session_attached}' | awk -v s="$sname" '$1 == s { print $2 }')"
        if [[ "$attached" == "0" ]]; then
            tmux attach-session -t "$sname"
            return
        fi
        # If already attached in another terminal, launch a distinct session
        sname="${sname}-$$"
    fi

    tmux new-session -s "$sname" -c "$PWD" "$pi_bin" "${args[@]}"
}
alias ip="ip -c"
alias open="xdg-open"
alias kiri="/home/0xShred/programming/codeberg/kiroku/target/debug/kiroku"
alias homelab="ssh gabriel@100.65.145.50"
alias proxmox='ssh pve'
alias vm='ssh k3s01'

# Resize images to 700px width (defaults to assets/*.png)
rzimg() {
    if [ $# -eq 0 ]; then
        magick mogrify -resize 700x assets/*.png 2>/dev/null && echo "Normalized assets/*.png to 700px width"
    else
        magick mogrify -resize 700x "$@" && echo "Normalized $@ to 700px width"
    fi
}
alias img700='rzimg'

# Clipboard History
alias cl="cliphist list | fzf | cliphist decode | wl-copy"

# global 
alias -g G='| grep'
alias -g L='| less'
alias -g C='| wc -l'  # Count lines
alias -g N='> /dev/null 2>&1' # Silence output

# Text files -> Open in nvim
alias -s {md,txt,json,toml,yaml,yml,ini,conf,zsh,java}=nvim

# Images/Documents -> Open in default viewer (xdg-open)
alias -s {png,jpg,jpeg,gif,pdf,mp4,mkv}=xdg-open

# rustaceans, I summon you all!
alias cb='cargo build'
alias cr='cargo run'
alias crq='cargo run --quiet'
alias ct='cargo test'
alias cf='cargo fmt --manifest-path Cargo.toml --all'
alias fct='cargo fmt --all && cargo clippy --all-targets -- -D warnings && cargo test'

# java / prog1 workflow
alias jclean='rm -f **/*.class(N)'
alias jdoc='javadoc -d doc -encoding UTF-8 -charset UTF-8 *.java'
alias mc='mvn clean compile'
alias mt='mvn test'
alias mp='mvn clean package'
alias gw='./gradlew'
alias gwb='./gradlew build'
alias gwt='./gradlew test'
alias j!=jbang

# lazygit
alias lg='lazygit'

# epoch
alias epoch='sudo /home/0xShred/.cargo/bin/epoch'

# pi-patch-prices
alias pi-patch-prices='node ~/dotfiles/pi/.pi/agent/scripts/patch-model-picker-price.mjs'

# audio
alias audio='wpctl'

# Zellij (Auto-attach or Create)
alias zlj='zellij attach --index 0 || zellij'

# conect to headphones
alias headphones='wpctl set-default $(wpctl status | sed -n "/Sinks:/,/Sources:/p" | grep "Nothing Ear" | grep -Eo "[0-9]+" | head -n 1)'

# clean logs 
alias cleanroot='sudo pacman -Scc && sudo journalctl --vacuum-size=100M && sudo timeshift --check'

# increase constrast
alias gamma='gammastep -m wayland -O 6500 -g 1.3'

# reaper low latency when sharing browsers output
alias reaper-lowlat='PIPEWIRE_LATENCY=128/48000 pw-jack reaper'

# --- 8. FUNCTIONS ---

# Java build (Maven / Gradle / standalone javac)
jc() {
    if [[ -f pom.xml ]]; then
        mvn compile "$@"
    elif [[ -f gradlew ]]; then
        ./gradlew compileJava "$@"
    elif [[ -f build.gradle || -f build.gradle.kts ]]; then
        gradle compileJava "$@"
    elif [[ $# -gt 0 ]]; then
        javac -g "$@"
    else
        javac -g *.java
    fi
}

# Java run (strips .java/.class, auto-detects Main / main() / fzf picker)
jr() {
    local target="$1"
    if [[ -n "$target" ]]; then
        shift
        target="${target%.java}"
        target="${target%.class}"
    else
        if [[ -f "Main.class" || -f "Main.java" ]]; then
            target="Main"
        else
            local -a mains=( $(grep -lE "public\s+static\s+void\s+main" *.java(N) 2>/dev/null) )
            if [[ ${#mains[@]} -eq 1 ]]; then
                target="${mains[1]%.java}"
            elif [[ ${#mains[@]} -gt 1 ]] && command -v fzf >/dev/null 2>&1; then
                target=$(printf "%s\n" "${mains[@]}" | fzf --prompt="Select main class: ")
                target="${target%.java}"
            else
                local -a java_files=( *.java(N) )
                if [[ ${#java_files[@]} -eq 1 ]]; then
                    target="${java_files[1]%.java}"
                fi
            fi
        fi
    fi

    if [[ -z "$target" ]]; then
        echo "Usage: jr [Class|File.java] [args...]"
        return 1
    fi

    if [[ -f "${target}.class" ]]; then
        java "$target" "$@"
    elif [[ -f "${target}.java" ]]; then
        java "${target}.java" "$@"
    else
        java "$target" "$@"
    fi
}

# Java compile & run in one shot
jcr() {
    jc && jr "$@"
}

# Java REPL (substitutes BlueJ object bench: loads .java files into interactive shell)
jsh() {
    local -a files=( *.java(N) )
    if [[ $# -gt 0 ]]; then
        jshell "$@"
    elif [[ ${#files[@]} -gt 0 ]]; then
        jshell --class-path . "${files[@]}"
    else
        jshell --class-path .
    fi
}

# Java test runner
jt() {
    if [[ -f pom.xml ]]; then
        mvn test "$@"
    elif [[ -f gradlew ]]; then
        ./gradlew test "$@"
    elif [[ -f build.gradle || -f build.gradle.kts ]]; then
        gradle test "$@"
    else
        echo "No build tool detected (pom.xml / build.gradle)."
    fi
}


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
    sudo -v || return 1

    echo -e "\n\033[1;34m[1/5] 📦 Updating System...\033[0m"
    if ! grep -Eq '^[[:space:]]*Server[[:space:]]*=' /etc/pacman.d/mirrorlist; then
        echo "No active pacman mirrors in /etc/pacman.d/mirrorlist"
        echo "Uncomment at least one Server line, then rerun sysmaintain."
        return 1
    fi

    sudo pacman-db-upgrade
    yay -Syu

    echo -e "\n\033[1;34m[2/5] 📦 Updating Flatpaks...\033[0m"
    flatpak update
    flatpak uninstall --unused

    echo -e "\n\033[1;34m[3/5] 🧹 Cleaning Orphans & Cache...\033[0m"
    orphans=$(pacman -Qtdq)
    [[ -n "$orphans" ]] && sudo pacman -Rns $orphans
    sudo paccache -rk2
    sudo paccache -ruk0

    echo -e "\n\033[1;34m[4/5] 🧩 Checking Config Diffs...\033[0m"
    sudo pacdiff

    echo -e "\n\033[1;34m[5/5] 🚑 Checking Errors...\033[0m"
    systemctl --failed
    journalctl -p 3 -xb --no-pager

    echo -e "\n\033[1;32m✅ Maintenance Complete.\033[0m"
}

sysmaintian() {
    sysmaintain "$@"
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

# --- 10. TOOL INTEGRATIONS & PROMPT ---
# Starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# navi
command -v navi >/dev/null 2>&1 && eval "$(navi widget zsh)"

# direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# broot
[ -f "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"

# Source all configuration snippets from zshrc.d
if [ -d ~/.config/zshrc.d ]; then
    for f in ~/.config/zshrc.d/*.{sh,zsh}(N); do
        source "$f"
    done
fi

# Syntax highlighting (MUST be loaded at the very end)
for plugin in \
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /opt/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    $HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
    if [[ -f "$plugin" ]]; then source "$plugin"; break; fi
done
