# Ultimate Frontend Developer Setup

A complete and optimized setup script for frontend development environments on **Ubuntu / Linux Mint / Debian**.

## Quick Install (Recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mohammadhossein-asadi/frontend-dev-setup/main/setup.sh)
```

## Install via Clone

```bash
git clone https://github.com/mohammadhossein-asadi/frontend-dev-setup.git
cd frontend-dev-setup
chmod +x setup.sh
./setup.sh
```

## What gets installed?

- Node.js (via nvm) + pnpm + yarn + TypeScript tools
- Bun + Deno
- VS Code + essential extensions + optimized settings
- Zsh + Oh My Zsh + Powerlevel10k + powerful plugins
- Fonts: MesloLGS NF + Vazirmatn + Fira Code + JetBrains Mono
- Official Telegram Desktop (no Snap)
- Google Chrome
- Docker (optional)
- Bilingual keyboard support (English + Persian)

## Important Notes

- The script is fully interactive and asks for confirmation at each step.
- Tested on Linux Mint and Ubuntu.
- It will **not** configure Git identity or generate SSH keys without your permission.

## After Installation

1. Logout and login again (or reboot)
2. Open a new terminal
3. Run: `p10k configure`
4. Select **MesloLGS NF** when asked about the font

---

Made for frontend developers
