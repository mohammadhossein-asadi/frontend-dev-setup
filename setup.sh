#!/usr/bin/env bash

# =============================================================================
# Ultimate Frontend Developer Setup v6.1.0 (Complete Combined)
# No removals | Fully interactive | Debian / Ubuntu / Linux Mint optimized
# =============================================================================

set -o pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "\n${CYAN}${BOLD}==================================================${NC}"
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${CYAN}${BOLD}==================================================${NC}\n"
}
print_success() { echo -e "${GREEN}[✓] $1${NC}"; }
print_info()    { echo -e "${BLUE}[i] $1${NC}"; }
print_warning() { echo -e "${YELLOW}[!] $1${NC}"; }
print_error()   { echo -e "${RED}[✗] $1${NC}"; }

ask_yes_no() {
    local prompt="$1"
    local default="${2:-N}"
    local reply
    if [[ "$default" == "Y" ]]; then
        read -p "$prompt [Y/n]: " -n 1 -r reply
    else
        read -p "$prompt [y/N]: " -n 1 -r reply
    fi
    echo
    [[ -z "$reply" ]] && reply="$default"
    [[ "$reply" =~ ^[Yy]$ ]]
}

# Root check
if [[ $EUID -eq 0 ]]; then
    print_error "Do NOT run as root. Use: ./setup.sh"
    exit 1
fi

# =============================================================================
# 0. System Detection
# =============================================================================
print_header "0. System Detection"

if [[ ! -f /etc/os-release ]]; then
    print_error "/etc/os-release not found"
    exit 1
fi

source /etc/os-release

OS_ID="${ID:-unknown}"
OS_NAME="${PRETTY_NAME:-$NAME}"
OS_VERSION="${VERSION_ID:-unknown}"
UBUNTU_CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME:-noble}}"
ARCH="$(dpkg --print-architecture 2>/dev/null || uname -m)"

print_info "OS       : $OS_NAME"
print_info "Version  : $OS_VERSION"
print_info "Codename : $UBUNTU_CODENAME"
print_info "Arch     : $ARCH"

# =============================================================================
# Confirmation
# =============================================================================
print_header "Ultimate Frontend Developer Setup v6.1.0"
echo "This complete script includes:"
echo "  • APT repair + full upgrade"
echo "  • Base tools + Audacious + VLC + mpv + Celluloid"
echo "  • Fonts: MesloLGS NF + Vazirmatn + Fira Code + JetBrains Mono"
echo "  • Bilingual keyboard (EN + FA)"
echo "  • nvm + Node LTS + pnpm + yarn + TypeScript tools"
echo "  • Bun + Deno"
echo "  • VS Code + extensions + full settings"
echo "  • Google Chrome"
echo "  • Official Telegram (no Snap)"
echo "  • Git (optional identity)"
echo "  • SSH key (optional)"
echo "  • Docker (optional, Mint-compatible)"
echo "  • Zsh + Oh My Zsh + Powerlevel10k + plugins"
echo "  • Powerful optimized .zshrc"
echo "  • Terminal font configuration"
echo "  • Light system optimizations (optional)"
echo

if ! ask_yes_no "Continue with full installation?" "Y"; then
    print_warning "Cancelled."
    exit 0
fi

# Keep sudo alive
sudo -v
(
    while true; do
        sudo -n true
        sleep 50
        kill -0 "$$" 2>/dev/null || exit
    done
) 2>/dev/null &
SUDO_PID=$!
trap 'kill $SUDO_PID 2>/dev/null || true' EXIT

# =============================================================================
# 1. APT Repair + Update
# =============================================================================
print_header "1. APT Repair & System Update"

export DEBIAN_FRONTEND=noninteractive

sudo dpkg --configure -a || true
sudo apt-get -f install -y || true
sudo rm -rf /var/lib/apt/lists/partial 2>/dev/null || true
sudo apt-get clean || true

print_info "Updating package lists..."
if ! sudo apt-get update -o Acquire::Retries=5; then
    print_warning "Retrying after cleaning lists..."
    sudo rm -rf /var/lib/apt/lists/*
    sudo apt-get clean
    sudo apt-get update -o Acquire::Retries=5
fi

print_info "Upgrading system..."
sudo apt-get upgrade -y || true
sudo apt-get full-upgrade -y || true
sudo apt-get autoclean -y || true

print_success "System updated."

# =============================================================================
# 2. Base + Media Packages
# =============================================================================
print_header "2. Installing Base & Media Packages"

BASE_PACKAGES=(
    build-essential curl wget git gpg ca-certificates
    software-properties-common apt-transport-https gnupg
    lsb-release unzip zip tar gzip xz-utils bzip2
    htop btop neofetch tree jq xclip wl-clipboard
    fzf ripgrep bat eza fd-find fontconfig
    fonts-firacode fonts-jetbrains-mono fonts-noto-color-emoji
    language-pack-fa language-pack-gnome-fa
    openssh-client net-tools dnsutils iproute2 tmux ncdu
)

print_info "Installing base packages..."
sudo apt-get install -y --fix-missing "${BASE_PACKAGES[@]}" || true

for pkg in audacious vlc mpv celluloid; do
    if sudo apt-get install -y --fix-missing "$pkg" 2>/dev/null; then
        print_success "$pkg installed"
    else
        print_warning "Could not install $pkg (skipped)"
    fi
done

# fd symlink
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd 2>/dev/null || true
fi

print_success "Packages installed."

# =============================================================================
# 3. Fonts
# =============================================================================
print_header "3. Installing Fonts (MesloLGS NF + Vazirmatn)"

mkdir -p "$HOME/.local/share/fonts"
MESLO_DIR="$HOME/.local/share/fonts/MesloLGS-NF"
mkdir -p "$MESLO_DIR"
MESLO_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"

for font in \
    "MesloLGS NF Regular.ttf" \
    "MesloLGS NF Bold.ttf" \
    "MesloLGS NF Italic.ttf" \
    "MesloLGS NF Bold Italic.ttf"
do
    if [[ -s "$MESLO_DIR/$font" ]]; then
        print_info "Already have: $font"
        continue
    fi
    encoded="${font// /%20}"
    print_info "Downloading $font..."
    if curl -fL --retry 5 --connect-timeout 20 \
        "$MESLO_BASE/$encoded" -o "$MESLO_DIR/$font"; then
        chmod 644 "$MESLO_DIR/$font"
        print_success "Installed $font"
    else
        print_warning "Failed: $font"
    fi
done

cp -f "$MESLO_DIR"/*.ttf "$HOME/.local/share/fonts/" 2>/dev/null || true

# Vazirmatn
if ! fc-list 2>/dev/null | grep -qi "Vazirmatn"; then
    print_info "Installing Vazirmatn..."
    VAZIR_TMP=$(mktemp -d)
    if curl -fL --retry 5 \
        "https://github.com/rastikerdar/vazirmatn/releases/latest/download/Vazirmatn.zip" \
        -o "$VAZIR_TMP/Vazirmatn.zip"; then
        unzip -oq "$VAZIR_TMP/Vazirmatn.zip" -d "$VAZIR_TMP"
        find "$VAZIR_TMP" -type f \( -iname "*.ttf" -o -iname "*.otf" \) \
            -exec cp -f {} "$HOME/.local/share/fonts/" \;
        print_success "Vazirmatn installed"
    fi
    rm -rf "$VAZIR_TMP"
fi

sudo apt-get install -y fonts-vazirmatn 2>/dev/null || true
fc-cache -f >/dev/null 2>&1 || true
print_success "Fonts ready."

# =============================================================================
# 4. Keyboard & Locale
# =============================================================================
print_header "4. Language & Keyboard (EN + FA)"

sudo locale-gen fa_IR.UTF-8 2>/dev/null || true
sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 2>/dev/null || true

if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ir')]" 2>/dev/null || true
    gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle']" 2>/dev/null || true
    print_success "Keyboard: Alt + Shift to switch"
fi

mkdir -p "$HOME/.config/fontconfig"
cat > "$HOME/.config/fontconfig/fonts.conf" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match>
    <test name="lang" compare="contains">
      <string>fa</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Vazirmatn</string>
    </edit>
  </match>
</fontconfig>
EOF
fc-cache -f >/dev/null 2>&1 || true

# =============================================================================
# 5. nvm + Node
# =============================================================================
print_header "5. nvm + Node.js LTS"

if [[ ! -d "$HOME/.nvm" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"

nvm install --lts
nvm alias default 'lts/*'
nvm use default

npm install -g pnpm yarn typescript ts-node nodemon eslint prettier
print_success "Node $(node -v) | npm $(npm -v) | pnpm $(pnpm -v 2>/dev/null || echo n/a)"

# =============================================================================
# 6. Bun
# =============================================================================
print_header "6. Bun"
if ! command -v bun >/dev/null 2>&1; then
    curl -fsSL https://bun.sh/install | bash
fi
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
print_success "Bun ready"

# =============================================================================
# 7. Deno
# =============================================================================
print_header "7. Deno"
if ! command -v deno >/dev/null 2>&1; then
    curl -fsSL https://deno.land/install.sh | sh
fi
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
print_success "Deno ready"

# =============================================================================
# 8. VS Code
# =============================================================================
print_header "8. Visual Studio Code"

if ! command -v code >/dev/null 2>&1; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
        sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
    rm -f /tmp/packages.microsoft.gpg
    sudo apt-get update
    sudo apt-get install -y code
fi

print_info "Installing extensions..."
for ext in \
    dbaeumer.vscode-eslint esbenp.prettier-vscode bradlc.vscode-tailwindcss \
    formulahq.auto-rename-tag christian-kohler.path-intellisense eamodio.gitlens \
    usernamehw.errorlens dsznajder.es7-react-js-snippets \
    ms-vscode.vscode-typescript-next PKief.material-product-icons \
    denoland.vscode-deno oven.bun-vscode ms-azuretools.vscode-docker
do
    code --install-extension "$ext" --force >/dev/null 2>&1 || true
done

VSCODE_DIR="$HOME/.config/Code/User"
mkdir -p "$VSCODE_DIR"

cat > "$VSCODE_DIR/settings.json" << 'EOF'
{
  "editor.fontFamily": "'Fira Code', 'Vazirmatn', 'JetBrains Mono', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 15,
  "editor.lineHeight": 1.65,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "editor.minimap.enabled": true,
  "editor.smoothScrolling": true,
  "editor.cursorSmoothCaretAnimation": "on",
  "editor.cursorBlinking": "smooth",
  "editor.renderWhitespace": "selection",
  "editor.linkedEditing": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "explicit"
  },
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "files.exclude": { "**/.git": true, "**/node_modules": true },
  "workbench.colorTheme": "Default Dark Modern",
  "workbench.iconTheme": "material-product-icons",
  "workbench.startupEditor": "none",
  "workbench.editor.enablePreview": false,
  "terminal.integrated.fontFamily": "'MesloLGS NF', 'Fira Code', 'Vazirmatn', monospace",
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.defaultProfile.linux": "zsh",
  "prettier.semi": true,
  "prettier.singleQuote": true,
  "prettier.trailingComma": "es5",
  "prettier.printWidth": 100,
  "prettier.tabWidth": 2,
  "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact"],
  "eslint.format.enable": true,
  "typescript.updateImportsOnFileMove.enabled": "always",
  "javascript.updateImportsOnFileMove.enabled": "always",
  "git.autofetch": true,
  "git.confirmSync": false,
  "git.enableSmartCommit": true,
  "explorer.confirmDelete": false,
  "explorer.confirmDragAndDrop": false,
  "security.workspace.trust.enabled": false,
  "deno.enable": false,
  "emmet.includeLanguages": {
    "javascript": "javascriptreact",
    "typescript": "typescriptreact"
  }
}
EOF

print_success "VS Code configured."

# =============================================================================
# 9. Chrome
# =============================================================================
print_header "9. Google Chrome"

if ! command -v google-chrome >/dev/null 2>&1 && ! command -v google-chrome-stable >/dev/null 2>&1; then
    if [[ "$ARCH" == "amd64" ]]; then
        wget -q --tries=5 https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
        sudo apt-get install -y /tmp/chrome.deb || sudo dpkg -i /tmp/chrome.deb
        rm -f /tmp/chrome.deb
        print_success "Chrome installed"
    else
        print_warning "Chrome skipped on $ARCH"
    fi
else
    print_info "Chrome already installed"
fi

# =============================================================================
# 10. Telegram
# =============================================================================
print_header "10. Official Telegram"

TELEGRAM_DIR="$HOME/.local/share/Telegram"
if [[ ! -x "$TELEGRAM_DIR/Telegram" ]]; then
    print_info "Downloading official Telegram..."
    cd /tmp
    wget -q --tries=5 https://telegram.org/dl/desktop/linux -O telegram.tar.xz
    mkdir -p "$HOME/.local/share"
    tar -xJf telegram.tar.xz -C "$HOME/.local/share/"
    rm -f telegram.tar.xz

    mkdir -p "$HOME/.local/share/applications"
    cat > "$HOME/.local/share/applications/telegram-desktop.desktop" << EOF
[Desktop Entry]
Name=Telegram
Comment=Official Telegram Desktop
Exec=$HOME/.local/share/Telegram/Telegram -- %u
Icon=telegram
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
StartupWMClass=TelegramDesktop
MimeType=x-scheme-handler/tg;
EOF
    print_success "Telegram installed"
else
    print_info "Telegram already installed"
fi

# =============================================================================
# 11. Git + SSH (Optional)
# =============================================================================
print_header "11. Git & SSH (Optional)"

if ask_yes_no "Configure Git name and email now?"; then
    read -p "Full name: " git_name
    read -p "Email: " git_email
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global core.editor "code --wait"
    git config --global pull.rebase false
    git config --global push.autoSetupRemote true
    print_success "Git identity set"
else
    print_info "Git identity skipped"
fi

if ask_yes_no "Generate SSH key (ed25519) for GitHub?"; then
    if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
        email_for_ssh=$(git config --global user.email 2>/dev/null || echo "user@example.com")
        ssh-keygen -t ed25519 -C "$email_for_ssh" -f "$HOME/.ssh/id_ed25519" -N ""
        eval "$(ssh-agent -s)" >/dev/null
        ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null || true
        print_success "SSH key generated"
        echo -e "\n${YELLOW}=== Public SSH Key ===${NC}"
        cat "$HOME/.ssh/id_ed25519.pub"
        echo -e "${YELLOW}======================${NC}"
        echo "Add to GitHub → Settings → SSH and GPG keys"
    else
        print_info "SSH key already exists"
        cat "$HOME/.ssh/id_ed25519.pub"
    fi
fi

# =============================================================================
# 12. Docker (Optional)
# =============================================================================
print_header "12. Docker (Optional)"

if ask_yes_no "Install Docker Engine + Compose?"; then
    for f in /etc/apt/sources.list.d/*docker*; do
        [[ -e "$f" ]] || continue
        sudo mv "$f" "/etc/apt/sources.list.d/docker-backup-$(date +%s)-$(basename "$f")" 2>/dev/null || true
    done

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc >/dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER"
    sudo systemctl enable --now docker 2>/dev/null || true
    print_success "Docker installed (logout required)"
else
    print_info "Docker skipped"
fi

# =============================================================================
# 13. Zsh + Powerlevel10k
# =============================================================================
print_header "13. Zsh + Oh My Zsh + Powerlevel10k"

sudo apt-get install -y zsh zsh-common

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)" 2>/dev/null || true
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting zsh-users/zsh-completions Aloxaf/fzf-tab; do
    name=$(basename "$repo")
    [[ ! -d "$ZSH_CUSTOM/plugins/$name" ]] && \
        git clone --depth=1 "https://github.com/$repo.git" "$ZSH_CUSTOM/plugins/$name"
done

print_success "Zsh + Powerlevel10k ready."

# =============================================================================
# 14. .zshrc
# =============================================================================
print_header "14. Writing powerful .zshrc"

[[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"

cat > "$HOME/.zshrc" << 'ZSHRC_EOF'
# =============================================================================
# Ultra Powerful Optimized .zshrc - Frontend Developer
# =============================================================================

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git nvm node npm yarn docker docker-compose
  zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf-tab
  history sudo extract z web-search copyfile copypath dirhistory
)

DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='code --wait'
export VISUAL='code --wait'

HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_FIND_NO_DUPS
setopt SHARE_HISTORY EXTENDED_HISTORY INC_APPEND_HISTORY

export PATH="$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Modern tools
alias ls='eza --icons --group-directories-first --color=always'
alias ll='eza -la --icons --group-directories-first --git --header'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias cat='batcat --style=plain --paging=never' 2>/dev/null || alias cat='bat --style=plain --paging=never' 2>/dev/null || true
alias grep='rg --color=auto --smart-case'
alias find='fd --hidden --exclude .git --exclude node_modules' 2>/dev/null || alias find='fdfind' 2>/dev/null || true
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y'
alias reload='source ~/.zshrc && echo "✓ Reloaded"'

# Git
alias g='git' gs='git status -sb' ga='git add' gaa='git add --all'
alias gc='git commit' gp='git push' gpl='git pull --rebase'
alias gl='git log --oneline --graph --decorate -15' gd='git diff' gb='git branch'
alias gco='git checkout' gcb='git checkout -b' gst='git stash' gstp='git stash pop'

# Package managers
alias p='pnpm' pi='pnpm install' pd='pnpm dev' pb='pnpm build' pt='pnpm test'
alias b='bun' bi='bun install' bd='bun dev' bb='bun run build'
alias ni='npm install' nr='npm run' nrd='npm run dev' nrb='npm run build'
alias y='yarn' ya='yarn add' yd='yarn dev'

# Docker
alias d='docker' dc='docker compose' dps='docker ps' dcup='docker compose up -d'
alias dcdown='docker compose down' dclogs='docker compose logs -f'

# Useful functions
mkcd() { mkdir -p "$@" && cd "$_"; }
gcm() {
  if [ $# -eq 0 ]; then echo "Usage: gcm <message> or gcm <type> <message>"; return 1; fi
  case "$1" in
    feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert)
      local type=$1; shift; git commit -m "$type: $*" ;;
    *) git commit -m "$*" ;;
  esac
}
gacp() { git add -A && git commit -m "$*" && git push; }

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC_EOF

print_success ".zshrc written."

# =============================================================================
# 15. Terminal Font
# =============================================================================
print_header "15. Terminal Font Configuration"

if command -v gsettings >/dev/null 2>&1; then
    PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d "'")
    if [[ -n "$PROFILE_ID" && "$PROFILE_ID" != "nothing" ]]; then
        SCHEMA="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE_ID}/"
        gsettings set "$SCHEMA" use-system-font false 2>/dev/null || true
        gsettings set "$SCHEMA" font "MesloLGS NF 13" 2>/dev/null || true
        print_success "GNOME Terminal → MesloLGS NF"
    fi
fi

# =============================================================================
# 16. Optional Optimizations
# =============================================================================
print_header "16. System Optimizations (Optional)"

if ask_yes_no "Apply light performance optimizations (inotify + swappiness)?"; then
    echo "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.d/99-dev-inotify.conf >/dev/null
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-dev-inotify.conf >/dev/null
    sudo sysctl --system >/dev/null 2>&1 || true
    print_success "sysctl tuned"
else
    print_info "Optimizations skipped"
fi

# =============================================================================
# Finish
# =============================================================================
print_header "Installation completed successfully! 🚀"

echo -e "${GREEN}Installed / configured:${NC}"
echo "  • Base tools + multimedia players"
echo "  • MesloLGS NF + Vazirmatn + Fira Code + JetBrains Mono"
echo "  • Bilingual keyboard (Alt + Shift)"
echo "  • nvm + Node.js LTS + pnpm + yarn + TypeScript tools"
echo "  • Bun + Deno"
echo "  • VS Code + extensions + settings"
echo "  • Google Chrome"
echo "  • Official Telegram"
echo "  • Git / SSH (if selected)"
echo "  • Docker (if selected)"
echo "  • Zsh + Oh My Zsh + Powerlevel10k + plugins"
echo "  • Powerful optimized .zshrc"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Logout and login again (or reboot)"
echo "  2. Open a new terminal"
echo "  3. Run:  p10k configure"
echo "  4. Select MesloLGS NF when asked"
echo "  5. Test:  eza --icons=always"
echo "  6. Test:  fc-match 'MesloLGS NF'"
echo
echo -e "${GREEN}Everything is ready. Enjoy coding!${NC}"
