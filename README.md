# bspwm dotfiles — ThinkPad T14 AMD

This is my personal Arch Linux setup based on [Zproger's bspwm dotfiles](https://github.com/Zproger/bspwm-dotfiles).
I rewrote the installer for my hardware, stripped out everything I don't use (mpd, ncmpcpp, nvim, ranger, redshift, zathura), and tuned the configs to my taste.

> **Before you start:** these dotfiles are built around specific hardware (ThinkPad T14 Gen 1 AMD, Ryzen 7 PRO 5850U).
> Battery name, backlight device, monitor output — all of these will likely differ on your machine.
> The sections below tell you exactly what to check and where to change it.

---

## What's included

| Path | What it configures |
|---|---|
| `bspwm/` | Window manager — border colors, autostart, monitor setup |
| `polybar/` | Status bar — modules, icons, appearance |
| `sxhkd/` | Keybindings — layout switching, screenshots, etc. |
| `fish/` | Fish shell config and functions (including `p-low`, `p-med`, `p-hight`) |
| `gtk-3.0/` | GTK theme (Dracula pink accent, dark mode) |
| `rofi/` | Application launcher |
| `alacritty/` | Terminal emulator |
| `bin/` | Custom scripts — lock screen, wallpaper, volume, battery alert, `yt`, `yt-clean` |
| `sddm/` | Login screen (sugar-candy theme) |
| `auto-cpufreq/` | CPU power management config + sudoers rule |
| `firefox-prefs.js` | Dark theme for Firefox |

---

## Hardware-specific things to fix after install

Polybar reads hardware names directly from the system, so several values **will not match your machine** out of the box.

**Battery**

Check your battery name:
```bash
ls /sys/class/power_supply/
```
It's usually `BAT0` or `BAT1`. Then update two files:
- `~/.config/polybar/modules.ini` — find `[module/battery]`, change `battery = BAT0` to your value
- `~/bin/battery-alert` — change the `battery` variable at the top of the script

**Backlight**

Check your backlight device:
```bash
ls /sys/class/backlight/
```
On AMD it's usually `amdgpu_bl0` or `amdgpu_bl1`. Update `[module/backlight]` in `~/.config/polybar/modules.ini`.

**Monitor output**

Check your display output name:
```bash
xrandr | grep " connected"
```
It's usually `eDP` or `eDP-1` depending on your kernel/driver version. Update `~/.config/bspwm/dual_monitors.sh` and `~/.config/polybar/config.ini` if needed.

---

## Installation

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/bspwm-dotfiles.git
cd bspwm-dotfiles
```

### 2. Copy configs

```bash
cp -r bspwm ~/.config/
cp -r polybar ~/.config/
cp -r sxhkd ~/.config/
cp -r fish ~/.config/
cp -r gtk-3.0 ~/.config/
cp -r rofi ~/.config/
cp -r alacritty ~/.config/
cp -r bin ~/
chmod +x ~/bin/*
```

### 3. Apply GTK theme

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula-pink-accent'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'pink'
```

### 4. CPU power management

```bash
mkdir -p ~/.config/auto-cpufreq
cp auto-cpufreq/auto-cpufreq.conf ~/.config/auto-cpufreq/
sudo cp auto-cpufreq/sudoers-auto-cpufreq /etc/sudoers.d/auto-cpufreq
sudo systemctl restart auto-cpufreq
```

After this, fish functions `p-low`, `p-med`, `p-hight` will work without sudo password.

### 5. SDDM login screen

```bash
sudo cp sddm/theme.conf /etc/sddm.conf.d/
sudo cp -r sddm/sugar-candy /usr/share/sddm/themes/
```

### 6. Firefox dark theme

```bash
# Find your profile folder
find ~/.config/mozilla/firefox -name "prefs.js"
# Copy (replace XXXXX with your actual profile folder name)
cp firefox-prefs.js ~/.config/mozilla/firefox/XXXXX.default-release/prefs.js
```

> Note: Firefox profile is at `~/.config/mozilla/firefox/` — not `~/.mozilla/`. This is specific to the Zproger build.

### 7. xkblayout-state (keyboard layout switching)

The language switching script depends on `xkblayout-state`. Build it from source:

```bash
git clone https://github.com/nonpop/xkblayout-state ~/bin/xkblayout-state
cd ~/bin/xkblayout-state && make
```

---

## Scripts in `bin/`

Most scripts are from the original Zproger build. The ones I added:

- **`yt`** — download video or audio via yt-dlp. Usage: `yt mp3 'URL'` or `yt mp4 [-l|-m|-h] 'URL'`
- **`yt-clean`** — helper called by `yt`, cleans up filename encoding in downloaded MP3s

These require `yt-dlp` and `python-mutagen` to be installed:
```bash
sudo pacman -S yt-dlp python-mutagen
pip install unidecode --break-system-packages
```

---

## Known gotchas

- **Username must be `user`** — the original Zproger configs hardcode `/home/user/` in several paths. If your username is different, you'll need to do a find-and-replace across the configs.
- **GTK theme needs to match in two places** — `gtk-3.0/settings.ini` and `gsettings`. If they're out of sync, the accent color will revert.
- **Don't set `GTK_THEME=Adwaita:dark`** in `fish/config.fish` — it overrides the Dracula theme.
- **`p-low` / `p-med` / `p-hight`** are fish functions in `fish/functions/`. Fish loads them automatically, no extra steps needed.
- **Polybar may not show at all** if the monitor name doesn't match. Check `dual_monitors.sh` and `config.ini` first.

---

## Updating the backup

When you change something on the live system and want to sync it to the repo:

```bash
rsync -a --delete ~/.config/bspwm/ ~/zproger-bspwm-dots/bspwm/
# ... same for other folders you changed
cd ~/zproger-bspwm-dots
git add .
git commit -m "describe what you changed"
git push
```

---

## System info

- **OS:** Arch Linux
- **WM:** BSPWM (based on Zproger build)
- **Bar:** Polybar
- **Terminal:** Alacritty
- **Shell:** Fish
- **GTK Theme:** Dracula-pink-accent
- **SDDM Theme:** sugar-candy
- **Hardware:** ThinkPad T14 Gen 1 AMD / Ryzen 7 PRO 5850U / Radeon Vega

---

---

# bspwm dotfiles — ThinkPad T14 AMD (RU)

Мой личный сетап Arch Linux на базе [dotfiles от Zproger](https://github.com/Zproger/bspwm-dotfiles).
Я переписал установщик под своё железо, вырезал всё что не использую (mpd, ncmpcpp, nvim, ranger, redshift, zathura) и подогнал конфиги под себя.

> **Перед началом:** эти конфиги заточены под конкретное железо (ThinkPad T14 Gen 1 AMD, Ryzen 7 PRO 5850U).
> Имя батареи, устройство подсветки, название монитора — всё это на твоей машине скорее всего будет другим.
> В разделах ниже написано что именно проверить и где менять.

---

## Что здесь хранится

| Путь | Что настраивает |
|---|---|
| `bspwm/` | Оконный менеджер — цвета обводки, автозапуск, настройка мониторов |
| `polybar/` | Панель — модули, иконки, внешний вид |
| `sxhkd/` | Хоткеи — смена раскладки, скриншоты и т.д. |
| `fish/` | Конфиг fish shell и функции (включая `p-low`, `p-med`, `p-hight`) |
| `gtk-3.0/` | GTK тема (Dracula розовый акцент, тёмный режим) |
| `rofi/` | Меню запуска приложений |
| `alacritty/` | Терминал |
| `bin/` | Кастомные скрипты — лок скрин, обои, громкость, battery-alert, `yt`, `yt-clean` |
| `sddm/` | Экран входа (тема sugar-candy) |
| `auto-cpufreq/` | Конфиг управления питанием CPU + правило sudoers |
| `firefox-prefs.js` | Тёмная тема Firefox |

---

## Что нужно поправить под своё железо

Polybar читает имена устройств напрямую из системы, поэтому несколько значений **не совпадут с твоей машиной** из коробки.

**Батарея**

Проверь имя батареи:
```bash
ls /sys/class/power_supply/
```
Обычно это `BAT0` или `BAT1`. Поправь в двух местах:
- `~/.config/polybar/modules.ini` — найди `[module/battery]`, смени `battery = BAT0` на своё значение
- `~/bin/battery-alert` — смени переменную `battery` в начале скрипта

**Подсветка экрана**

Проверь устройство подсветки:
```bash
ls /sys/class/backlight/
```
На AMD обычно `amdgpu_bl0` или `amdgpu_bl1`. Обнови `[module/backlight]` в `~/.config/polybar/modules.ini`.

**Название монитора**

Проверь имя выхода дисплея:
```bash
xrandr | grep " connected"
```
Обычно это `eDP` или `eDP-1` — зависит от версии ядра и драйвера. При необходимости обнови `~/.config/bspwm/dual_monitors.sh` и `~/.config/polybar/config.ini`.

---

## Установка

### 1. Клонируй репозиторий

```bash
git clone https://github.com/YOUR_USERNAME/bspwm-dotfiles.git
cd bspwm-dotfiles
```

### 2. Скопируй конфиги

```bash
cp -r bspwm ~/.config/
cp -r polybar ~/.config/
cp -r sxhkd ~/.config/
cp -r fish ~/.config/
cp -r gtk-3.0 ~/.config/
cp -r rofi ~/.config/
cp -r alacritty ~/.config/
cp -r bin ~/
chmod +x ~/bin/*
```

### 3. GTK тема через gsettings

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula-pink-accent'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'pink'
```

### 4. Управление питанием CPU

```bash
mkdir -p ~/.config/auto-cpufreq
cp auto-cpufreq/auto-cpufreq.conf ~/.config/auto-cpufreq/
sudo cp auto-cpufreq/sudoers-auto-cpufreq /etc/sudoers.d/auto-cpufreq
sudo systemctl restart auto-cpufreq
```

После этого fish-функции `p-low`, `p-med`, `p-hight` будут работать без пароля sudo.

### 5. Экран входа SDDM

```bash
sudo cp sddm/theme.conf /etc/sddm.conf.d/
sudo cp -r sddm/sugar-candy /usr/share/sddm/themes/
```

### 6. Тёмная тема Firefox

```bash
# Найди папку профиля
find ~/.config/mozilla/firefox -name "prefs.js"
# Скопируй (замени XXXXX на реальное имя папки профиля)
cp firefox-prefs.js ~/.config/mozilla/firefox/XXXXX.default-release/prefs.js
```

> Профиль Firefox лежит в `~/.config/mozilla/firefox/`, а не в `~/.mozilla/` — это особенность сборки Zproger.

### 7. xkblayout-state (переключение раскладки)

Скрипт смены языка зависит от `xkblayout-state`. Собери из исходников:

```bash
git clone https://github.com/nonpop/xkblayout-state ~/bin/xkblayout-state
cd ~/bin/xkblayout-state && make
```

---

## Скрипты в `bin/`

Большинство скриптов из оригинальной сборки Zproger. Мои добавления:

- **`yt`** — скачивает видео или аудио через yt-dlp. Использование: `yt mp3 'URL'` или `yt mp4 [-l|-m|-h] 'URL'`
- **`yt-clean`** — хелпер, вызывается из `yt`, чистит кодировку имён у скачанных MP3

Требуют установки `yt-dlp` и `python-mutagen`:
```bash
sudo pacman -S yt-dlp python-mutagen
pip install unidecode --break-system-packages
```

---

## Важные нюансы

- **Имя пользователя должно быть `user`** — в оригинальных конфигах Zproger путь `/home/user/` захардкожен в нескольких местах. Если у тебя другое имя — придётся делать find-and-replace по всем конфигам.
- **GTK тема должна совпадать в двух местах** — `gtk-3.0/settings.ini` и `gsettings`. Если они расходятся, цвет акцента сбросится.
- **Не выставляй `GTK_THEME=Adwaita:dark`** в `fish/config.fish` — это перебивает тему Dracula.
- **`p-low` / `p-med` / `p-hight`** — fish-функции в `fish/functions/`. Fish подхватывает их автоматически, никаких дополнительных действий не нужно.
- **Polybar может вообще не появиться**, если название монитора не совпадает. Первым делом проверяй `dual_monitors.sh` и `config.ini`.

---

## Обновить бекап после изменений

Когда поменял что-то на живой системе и хочешь синхронизировать с репо:

```bash
rsync -a --delete ~/.config/bspwm/ ~/zproger-bspwm-dots/bspwm/
# ... то же самое для других папок которые менял
cd ~/zproger-bspwm-dots
git add .
git commit -m "описание что поменял"
git push
```

---

## Система

- **OS:** Arch Linux
- **WM:** BSPWM (на базе сборки Zproger)
- **Bar:** Polybar
- **Terminal:** Alacritty
- **Shell:** Fish
- **GTK Theme:** Dracula-pink-accent
- **SDDM Theme:** sugar-candy
- **Железо:** ThinkPad T14 Gen 1 AMD / Ryzen 7 PRO 5850U / Radeon Vega
