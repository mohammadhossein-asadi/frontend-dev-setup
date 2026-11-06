<div align="center" dir="rtl">

# Ultimate Frontend Developer Setup

**یک اسکریپت تعاملی برای راه‌اندازی کامل محیط توسعهٔ فرانت‌اند روی Ubuntu، Linux Mint و Debian.**

[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)](setup.sh)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Linux%20Mint%20%7C%20Debian-E95420?logo=ubuntu&logoColor=white)](#-پلتفرمهای-پشتیبانیشده)
[![Version](https://img.shields.io/badge/Setup-v6.1.0-blue)](setup.sh)
[![License](https://img.shields.io/badge/License-Not%20specified-lightgrey)](#-مجوز)

[🇬🇧 English](README.md) • [🇮🇷 فارسی](README.fa.md) • [🚀 شروع سریع](#-شروع-سریع) • [✨ چه چیزهایی نصب می‌شود](#-چه-چیزهایی-نصب-میشود) • [🔒 ایمنی](#-ایمنی)

</div>

---

## 🌟 معرفی

<div dir="rtl">

**Ultimate Frontend Developer Setup** یک اسکریپت Bash واحد و کاملاً تعاملی (`setup.sh` نسخهٔ 6.1.0) است که یک سیستم لینوکسی مبتنی بر Debian را برای توسعهٔ فرانت‌اند آماده می‌کند. این اسکریپت ابتدا APT را تعمیر/به‌روزرسانی می‌کند، سپس ابزارهای اصلی توسعه و چندرسانه‌ای، ران‌تایم‌های Node، ادیتور، ترمینال، فونت‌ها و در صورت تمایل Git/SSH/Docker را نصب و پیکربندی می‌کند — و در هر مرحلهٔ مهم از شما تأیید می‌گیرد.

</div>

### 🎯 چرا این پروژه؟

<div dir="rtl">

| راه‌اندازی ماشین لینوکسی معمولاً یعنی… | این اسکریپت کمک می‌کند با… |
| --- | --- |
| نصب تک‌به‌تک ران‌تایم‌ها، ادیتور، فونت و ابزارهای شل | ارائهٔ یک جریان راه‌اندازی هدایت‌شده و کامل برای فرانت‌اند |
| خرابی APT و توقف نصب‌ها | اجرای مراحل تعمیر/به‌روزرسانی APT پیش از نصب بسته‌ها |
| نبود فونت/آیکون درست در ترمینال و ادیتور | نصب MesloLGS NF، Vazirmatn، Fira Code، JetBrains Mono |
| ناهماهنگی شل و aliasها بین ماشین‌ها | نوشتن `.zshrc` بهینه با Powerlevel10k و aliasهای توسعه |
| تغییر ناخواستهٔ هویت Git یا کلید SSH | اختیاری و تعاملی بودن تنظیم هویت Git و ساخت کلید SSH |

</div>

---

## ✨ چه چیزهایی نصب می‌شود

<div dir="rtl">

### 🧰 ران‌تایم‌ها و مدیرهای بستهٔ فرانت‌اند
- **nvm** + **Node.js LTS** (alias پیش‌فرض: `lts/*`)
- ابزارهای سراسری npm: `pnpm`، `yarn`، `typescript`، `ts-node`، `nodemon`، `eslint`، `prettier`
- **Bun**
- **Deno**

### 💻 ادیتور و برنامه‌ها
- **Visual Studio Code** (از مخزن رسمی apt) + افزونه‌های منتخب
- فایل `settings.json` برای VS Code با تنظیمات مناسب فرانت‌اند (فرمت با Prettier/ESLint، به‌روزرسانی importهای TypeScript، ترمینال یکپارچه روی `zsh`)
- **Google Chrome** (روی amd64)
- **Telegram Desktop رسمی** (نصب از tarball، بدون Snap)

### 🐚 شل و تجربهٔ ترمینال
- **Zsh** + **Oh My Zsh** + **Powerlevel10k**
- پلاگین‌ها: `zsh-autosuggestions`، `zsh-syntax-highlighting`، `zsh-completions`، `fzf-tab` و پلاگین‌های Oh My Zsh (`git`، `nvm`، `node`، `npm`، `yarn`، `docker` و …)
- یک `~/.zshrc` بهینه و قدرتمند (از `.zshrc` قبلی بکاپ زمان‌دار می‌گیرد)
- تنظیم فونت GNOME Terminal روی **MesloLGS NF 13** در صورت امکان

### 🔤 فونت، زبان و کیبورد
- **MesloLGS NF** (برای Powerlevel10k)، **Vazirmatn** (فارسی)، **Fira Code**، **JetBrains Mono**، Noto Color Emoji
- کیبورد دوزبانه: **English (US) + Persian (IR)** با کلید تعویض **Alt+Shift** (در GNOME با `gsettings`)
- تولید locale `fa_IR.UTF-8` و تنظیم fontconfig برای متن فارسی

### 📦 ابزارهای پایه و چندرسانه‌ای
- ابزارهای سیستمی/ساخت: `build-essential`، `curl`، `wget`، `git`، `gpg`، `jq`، `tmux`، `htop/btop`، `ripgrep`، `fzf`، `bat`، `eza`، `fd-find` و …
- پخش‌کننده‌های رسانه (best-effort): `audacious`، `vlc`، `mpv`، `celluloid`

### 🔧 اختیاری (تعاملی)
- **هویت Git** (نام/ایمیل + پیش‌فرض‌های معقول)
- ساخت **کلید SSH** (`ed25519`) و نمایش کلید عمومی برای GitHub
- **Docker Engine + پلاگین Compose** (تنظیم مخزن سازگار با Mint/Ubuntu؛ افزودن کاربر به گروه `docker`)
- **بهینه‌سازی سبک سیستم** (`inotify` watches، `vm.swappiness=10`)

</div>

---

## 🖥️ پلتفرم‌های پشتیبانی‌شده

<div dir="rtl">

| پلتفرم | وضعیت |
| --- | --- |
| Ubuntu | پشتیبانی‌شده / هدف اصلی |
| Linux Mint | پشتیبانی‌شده / هدف اصلی |
| سیستم‌های مبتنی بر Debian | به‌صورت best-effort (اسکریپت برای Debian/Ubuntu/Mint طراحی شده) |

- **با کاربر root اجرا نشود.** به‌صورت کاربر عادی اجرا کنید: `./setup.sh` (اسکریپت در صورت نیاز از `sudo` استفاده می‌کند).
- در برخی بخش‌ها وابسته به معماری است (مثلاً Chrome روی `amd64` و معماری مخزن VS Code).

</div>

---

## 🏗️ نحوهٔ کار

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

### ساختار مخزن

```text
frontend-dev-setup/
├── README.md
├── README.fa.md
└── setup.sh          # نصب‌کنندهٔ تعاملی (v6.1.0)
```

---

## 🚀 شروع سریع

<div dir="rtl">

### نصب سریع (پیشنهادی)

</div>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mohammadhossein-asadi/frontend-dev-setup/main/setup.sh)
```

### نصب با clone

```bash
git clone https://github.com/mohammadhossein-asadi/frontend-dev-setup.git
cd frontend-dev-setup
chmod +x setup.sh
./setup.sh
```

---

## ✅ بعد از نصب

<div dir="rtl">

1. **یک‌بار logout/login کنید** (یا ریبوت) — برای اعمال تغییر شل/گروه‌ها (مثل `zsh` و گروه Docker) لازم است.
2. یک ترمینال جدید باز کنید.
3. اجرا کنید: `p10k configure`
4. هنگام پرسش فونت، **MesloLGS NF** را انتخاب کنید.
5. بررسی اختیاری:
   - `eza --icons=always`
   - `fc-match 'MesloLGS NF'`
   - `node -v && pnpm -v && bun -v && deno --version`

</div>

---

## 🔒 ایمنی

<div dir="rtl">

- **تعاملی بودن:** اسکریپت قبل از اقدامات مهم/اختیاری تأیید می‌گیرد.
- **بدون تغییر بی‌صدا:** تنظیم هویت Git و ساخت کلید SSH فقط در صورت انتخاب شما انجام می‌شود.
- **بکاپ:** از `~/.zshrc` قبلی قبل از جایگزینی بکاپ زمان‌دار گرفته می‌شود.
- **استفاده از شبکه:** بسته‌ها، نصب‌کننده‌ها، فونت‌ها و افزونه‌ها از منابع upstream (مخازن APT، GitHub، URLهای رسمی) دانلود می‌شوند. در صورت نیاز قبل از اجرا `setup.sh` را بررسی کنید.
- **تغییرات سیستمی:** از `sudo` استفاده می‌کند، منابع/کلیدهای apt را برای VS Code/Docker/Chrome تغییر می‌دهد، ممکن است شل ورود و sysctl (اختیاری) را تغییر دهد. روی سیستمی اجرا کنید که مالک و مسئول آن هستید.

</div>

---

## 🧩 افزونه‌های VS Code (نصب‌شده توسط اسکریپت)

<div dir="rtl">

`dbaeumer.vscode-eslint`، `esbenp.prettier-vscode`، `bradlc.vscode-tailwindcss`، `formulahq.auto-rename-tag`، `christian-kohler.path-intellisense`، `eamodio.gitlens`، `usernamehw.errorlens`، `dsznajder.es7-react-js-snippets`، `ms-vscode.vscode-typescript-next`، `PKief.material-product-icons`، `denoland.vscode-deno`، `oven.bun-vscode`، `ms-azuretools.vscode-docker`

</div>

---

## 🐚 alias/تابع‌های مفید (در `.zshrc` تولیدشده)

<div dir="rtl">

- CLI مدرن: `ls/ll/la/lt` (eza)، `cat` (bat)، `grep` (ripgrep)، `find` (fd)
- Git: `gs`، `gaa`، `gcm`، `gacp`، `gl`، `gco`، `gcb` و …
- مدیر بسته: `p/pi/pd/pb` (pnpm)، `b/bi/bd` (bun)، `nr/nrd` (npm)، `yd` (yarn)
- Docker: `d`، `dc`، `dcup`، `dcdown`، `dclogs`

</div>

---

## 🚨 رفع اشکال

<div dir="rtl">

| مشکل | راه‌حل پیشنهادی |
| --- | --- |
| اسکریپت می‌گوید با root اجرا نشود | با کاربر عادی اجرا کنید (نه `sudo ./setup.sh`) |
| خطا/قفل APT | مراحل تعمیر اسکریپت را طی کنید؛ مطمئن شوید فرایند apt دیگری در حال اجرا نیست |
| آیکون/پرومپت خراب است | `p10k configure` را اجرا و **MesloLGS NF** را انتخاب کنید؛ ترمینال را ریستارت کنید |
| خطای دسترسی `docker` | بعد از نصب Docker logout/login (یا ریبوت) کنید |
| Chrome نصب نشد | نصب Chrome برای `amd64` است؛ در معماری‌های دیگر رد می‌شود |
| افزونه/تنظیمات VS Code اعمال نشد | یک‌بار VS Code را باز کنید؛ در صورت نیاز افزونه‌ها را دوباره نصب کنید |

</div>

---

## 🤝 مشارکت

<div dir="rtl">

Issue و Pull Request خوش‌آمد هستند. اگر `setup.sh` را تغییر دادید:

1. تا حد امکان مراحل را **idempotent** نگه دارید (اجرای مجدد امن باشد).
2. **تأییدهای تعاملی** را برای اقدامات حساس/اختیاری حفظ کنید.
3. در صورت امکان روی VM تمیز Ubuntu/Linux Mint تست کنید.
4. هر دو فایل `README.md` و `README.fa.md` را به‌روز کنید.

</div>

---

## 📋 نقشهٔ راه

<div dir="rtl">

- [x] اسکریپت تعاملی راه‌اندازی فرانت‌اند برای Debian/Ubuntu/Mint
- [x] Node (nvm) + pnpm/yarn + Bun + Deno
- [x] Zsh + Oh My Zsh + Powerlevel10k + `.zshrc` بهینه
- [x] VS Code + افزونه‌ها + تنظیمات، Chrome، Telegram
- [x] اختیاری: هویت Git/SSH/Docker
- [ ] افزودن فایل LICENSE مشخص
- [ ] فلگ‌های اختیاری برای حالت غیرتعاملی/CI (در صورت ایمن بودن)
- [ ] پوشش توزیع/تست بیشتر و بررسی خودکار

</div>

---

## 📄 مجوز

<div dir="rtl">

در حال حاضر فایل `LICENSE` در این مخزن وجود ندارد. اگر قصد انتشار یا پذیرش مشارکت با شرایط مشخص دارید، مجوز اضافه کنید.

</div>

---

## 🙏 قدردانی

<div dir="rtl">

- **nvm**، **Node.js**، **pnpm**، **Yarn**، **Bun**، **Deno**
- **Zsh**، **Oh My Zsh**، **Powerlevel10k** و پلاگین‌های جامعه
- **VS Code**، **Google Chrome**، **Telegram Desktop**
- پروژه‌های فونت: **MesloLGS NF**، **Vazirmatn**، **Fira Code**، **JetBrains Mono**

</div>

---

<div align="center" dir="rtl">

**ساخته‌شده برای توسعه‌دهندگان فرانت‌اند روی لینوکس‌های مبتنی بر Debian.**

[🇬🇧 English](README.md) • [🇮🇷 فارسی](README.fa.md) • [⭐ ستاره در GitHub](https://github.com/mohammadhossein-asadi/frontend-dev-setup)

</div>
