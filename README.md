<div align="center">

# Ultimate Frontend Developer Setup

**One interactive script to bootstrap a complete frontend development environment on Ubuntu, Linux Mint, and Debian.**

[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)](setup.sh)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Linux%20Mint%20%7C%20Debian-E95420?logo=ubuntu&logoColor=white)](#-supported-platforms)
[![Version](https://img.shields.io/badge/Setup-v6.1.0-blue)](setup.sh)
[![License](https://img.shields.io/badge/License-Not%20specified-lightgrey)](#-license)

[🇬🇧 English](README.md) • [🇮🇷 فارسی](README.fa.md) • [🚀 Quick Start](#-quick-start) • [✨ What Gets Installed](#-what-gets-installed) • [🔒 Safety](#-safety)

</div>

---

## 🌟 Overview

**Ultimate Frontend Developer Setup** is a single, fully interactive Bash script (`setup.sh`, v6.1.0) that prepares a frontend-focused workstation on Debian-based Linux systems. It repairs/updates APT, installs core dev and media tools, configures Node.js runtimes, editors, terminals, fonts, and optional Git/SSH/Docker — with confirmation prompts at each major step.

### 🎯 Why this project?

| Starting a Linux dev machine can mean… | This setup helps by… |
| --- | --- |
| Installing runtimes, editors, fonts, and shell tools one by one | Providing a guided, end-to-end frontend setup flow |
| Broken APT state blocking installs | Running APT repair/update steps before installing packages |
| Missing fonts/icons in terminals and editors | Installing MesloLGS NF, Vazirmatn, Fira Code, JetBrains Mono |
| Inconsistent shell/aliases across machines | Writing an optimized `.zshrc` with Powerlevel10k and dev aliases |
| Accidental identity/key changes | Making Git identity and SSH key generation optional and interactive |

---

## ✨ What Gets Installed

### 🧰 Frontend runtimes & package managers
- **nvm** + **Node.js LTS** (default alias: `lts/*`)
- Global npm tools: `pnpm`, `yarn`, `typescript`, `ts-node`, `nodemon`, `eslint`, `prettier`
- **Bun**
- **Deno**

### 💻 Editor & apps
- **Visual Studio Code** (official apt repo) + curated extensions
- VS Code `settings.json` tuned for frontend work (Prettier/ESLint formatting, TypeScript import updates, integrated terminal set to `zsh`)
- **Google Chrome** (amd64)
- **Official Telegram Desktop** (tarball install, no Snap)

### 🐚 Shell & terminal experience
- **Zsh** + **Oh My Zsh** + **Powerlevel10k**
- Plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`, `fzf-tab`, plus Oh My Zsh plugins (`git`, `nvm`, `node`, `npm`, `yarn`, `docker`, etc.)
- A powerful optimized `~/.zshrc` (backups existing `.zshrc`)
- GNOME Terminal font configured to **MesloLGS NF 13** when available

### 🔤 Fonts, language & keyboard
- **MesloLGS NF** (Powerlevel10k), **Vazirmatn** (Persian), **Fira Code**, **JetBrains Mono**, Noto Color Emoji
- Bilingual keyboard sources: **English (US) + Persian (IR)** with **Alt+Shift** toggle (GNOME `gsettings`)
- `fa_IR.UTF-8` locale generation and fontconfig preference for Persian text

### 📦 Base tools & media
- Build/system utilities: `build-essential`, `curl`, `wget`, `git`, `gpg`, `jq`, `tmux`, `htop/btop`, `ripgrep`, `fzf`, `bat`, `eza`, `fd-find`, etc.
- Media players (best-effort): `audacious`, `vlc`, `mpv`, `celluloid`

### 🔧 Optional (interactive)
- **Git identity** (name/email + sensible defaults)
- **SSH key** generation (`ed25519`) and public key display for GitHub
- **Docker Engine + Compose plugin** (Mint/Ubuntu-compatible repo setup; adds user to `docker` group)
- **Light system optimizations** (`inotify` watches, `vm.swappiness=10`)

---

## 🖥️ Supported Platforms

| Platform | Status |
| --- | --- |
| Ubuntu | Supported / intended target |
| Linux Mint | Supported / intended target |
| Debian-based systems | Best-effort (script is Debian/Ubuntu/Mint oriented) |

- **Not for root execution.** Run as a normal user: `./setup.sh` (script uses `sudo` as needed).
- Architecture-aware in places (e.g., Chrome on `amd64`, VS Code repo arch).

---

## 🏗️ How It Works

```text
System detection (/etc/os-release, arch, codename)
      ↓
User confirmation + sudo keep-alive
      ↓
APT repair + update/upgrade
      ↓
Base/media packages + fonts + locale/keyboard
      ↓
nvm/Node + Bun + Deno
      ↓
VS Code (+ extensions/settings) + Chrome + Telegram
      ↓
Optional: Git identity, SSH key, Docker
      ↓
Zsh + Oh My Zsh + Powerlevel10k + plugins + .zshrc
      ↓
Terminal font + optional sysctl tuning + next steps
```

### Repository structure

```text
frontend-dev-setup/
├── README.md
├── README.fa.md
└── setup.sh          # Interactive installer (v6.1.0)
```

---

## 🚀 Quick Start

### Quick install (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mohammadhossein-asadi/frontend-dev-setup/main/setup.sh)
```

### Install via clone

```bash
git clone https://github.com/mohammadhossein-asadi/frontend-dev-setup.git
cd frontend-dev-setup
chmod +x setup.sh
./setup.sh
```

---

## ✅ After Installation

1. **Log out and log back in** (or reboot) — required for shell/group changes (e.g., `zsh`, Docker group).
2. Open a new terminal.
3. Run: `p10k configure`
4. Select **MesloLGS NF** when asked about the font.
5. Optional checks:
   - `eza --icons=always`
   - `fc-match 'MesloLGS NF'`
   - `node -v && pnpm -v && bun -v && deno --version`

---

## 🔒 Safety

- **Interactive by design:** the script asks for confirmation before major actions/optional sections.
- **No silent Git identity/SSH setup:** Git name/email and SSH key generation run only if you opt in.
- **Backups:** existing `~/.zshrc` is backed up before being replaced (timestamped).
- **Network use:** downloads packages, installers, fonts, and extensions from upstream sources (APT repos, GitHub, vendor URLs). Review `setup.sh` before running if needed.
- **System changes:** uses `sudo`, modifies apt sources/keyrings for VS Code/Docker/Chrome, may change login shell and sysctl (optional). Run on a machine you control and understand.

---

## 🧩 VS Code Extensions (installed by script)

`dbaeumer.vscode-eslint`, `esbenp.prettier-vscode`, `bradlc.vscode-tailwindcss`, `formulahq.auto-rename-tag`, `christian-kohler.path-intellisense`, `eamodio.gitlens`, `usernamehw.errorlens`, `dsznajder.es7-react-js-snippets`, `ms-vscode.vscode-typescript-next`, `PKief.material-product-icons`, `denoland.vscode-deno`, `oven.bun-vscode`, `ms-azuretools.vscode-docker`

---

## 🐚 Handy aliases/functions (from generated `.zshrc`)

- Modern CLI: `ls/ll/la/lt` (eza), `cat` (bat), `grep` (ripgrep), `find` (fd)
- Git: `gs`, `gaa`, `gcm`, `gacp`, `gl`, `gco`, `gcb`, …
- Package managers: `p/pi/pd/pb` (pnpm), `b/bi/bd` (bun), `nr/nrd` (npm), `yd` (yarn)
- Docker: `d`, `dc`, `dcup`, `dcdown`, `dclogs`

---

## 🚨 Troubleshooting

| Issue | What to try |
| --- | --- |
| Script exits asking not to run as root | Run `./setup.sh` as your normal user (not `sudo ./setup.sh`) |
| APT errors / locks | Let the script’s repair steps run; ensure no other apt process is running |
| Icons/prompt look broken | Run `p10k configure` and choose **MesloLGS NF**; restart terminal |
| `docker` permission denied | Log out/in (or reboot) after Docker install to apply group membership |
| Chrome not installed | Chrome install targets `amd64`; on other architectures it is skipped |
| VS Code extensions/settings not applied | Open VS Code once; rerun `code --install-extension ...` if needed |

---

## 🤝 Contributing

Issues and pull requests are welcome. If you change `setup.sh`:

1. Keep steps **idempotent** where possible (safe to re-run).
2. Preserve **interactive confirmations** for risky/optional actions.
3. Test on a fresh Ubuntu/Linux Mint VM when feasible.
4. Update both `README.md` and `README.fa.md`.

---

## 📋 Roadmap

- [x] Interactive Debian/Ubuntu/Mint frontend setup script
- [x] Node (nvm) + pnpm/yarn + Bun + Deno
- [x] Zsh + Oh My Zsh + Powerlevel10k + optimized `.zshrc`
- [x] VS Code + extensions + settings, Chrome, Telegram
- [x] Optional Git identity/SSH/Docker
- [ ] Add an explicit LICENSE file
- [ ] Optional flags for non-interactive/CI-friendly mode (where safe)
- [ ] More distro/testing coverage and automated checks

---

## 📄 License

No `LICENSE` file is currently present in this repository. Add a license if you plan to distribute or accept external contributions under specific terms.

---

## 🙏 Acknowledgments

- **nvm**, **Node.js**, **pnpm**, **Yarn**, **Bun**, **Deno**
- **Zsh**, **Oh My Zsh**, **Powerlevel10k**, and community plugins
- **VS Code**, **Google Chrome**, **Telegram Desktop**
- Font projects: **MesloLGS NF**, **Vazirmatn**, **Fira Code**, **JetBrains Mono**

---

<div align="center">

**Made for frontend developers on Debian-based Linux.**

[🇬🇧 English](README.md) • [🇮🇷 فارسی](README.fa.md) • [⭐ Star on GitHub](https://github.com/mohammadhossein-asadi/frontend-dev-setup)

</div>
