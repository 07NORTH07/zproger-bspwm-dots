# 🗂️ Arch Linux Dotfiles Backup
> Zproger BSPWM build — личный бекап конфигов

## 📦 Что здесь хранится

| Папка/Файл | Что настраивает |
|---|---|
| `bspwm/` | Оконный менеджер, цвета обводки окон, автозапуск |
| `polybar/` | Панель — иконки, модули, внешний вид |
| `sxhkd/` | Все хоткеи (смена раскладки, скриншоты и тд) |
| `fish/` | Fish shell, переменные окружения |
| `gtk-3.0/` | GTK тема (розовый акцент Dracula, dark mode) |
| `rofi/` | Меню запуска приложений |
| `alacritty/` | Терминал |
| `bin/` | Кастомные скрипты (лок скрин, обои, громкость и тд) |
| `sddm/` | Экран входа при включении ноута (тема sugar-candy) |
| `firefox-prefs.js` | Тёмная тема Firefox |
| `settings.ini` | GTK настройки (дубль для надёжности) |

---

## 🚀 Установка после переустановки системы

### 1. Основные конфиги
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

### 2. GTK тема через gsettings
```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula-pink-accent'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'pink'
```

### 3. SDDM экран входа
```bash
sudo cp sddm/theme.conf /etc/sddm.conf.d/
sudo cp -r sddm/sugar-candy /usr/share/sddm/themes/
```

### 4. Firefox тёмная тема
```bash
# Найти папку профиля
find ~/.config/mozilla/firefox -name "prefs.js"
# Скопировать (заменить XXXXX на реальное имя папки)
cp firefox-prefs.js ~/.config/mozilla/firefox/XXXXX.default-release/prefs.js
```

---

## 🔄 Обновить бекап после изменений

```bash
# Скопировать изменённый файл в бекап, например bspwmrc
cp ~/.config/bspwm/bspwmrc ~/my-backup/bspwm/

# Залить на GitHub
cd ~/my-backup
git add .
git commit -m "update bspwmrc"
git push
```

---

## ⚠️ Важные заметки

- **Профиль Firefox** лежит не в `~/.mozilla/` а в `~/.config/mozilla/firefox/` — это особенность билда Zproger
- **GTK тема** должна совпадать в двух местах: `settings.ini` и `gsettings` — иначе цвет выделения слетит
- **Переменная GTK_THEME** в `fish/config.fish` не должна быть выставлена на `Adwaita:dark` — это перебивает тему
- **SDDM конфиг** лежит в `/etc/sddm.conf.d/` — требует sudo для копирования

---

## 🖥️ Система

- **OS:** Arch Linux
- **WM:** BSPWM (Zproger build)
- **Bar:** Polybar
- **Terminal:** Alacritty
- **Shell:** Fish
- **GTK Theme:** Dracula-pink-accent
- **SDDM Theme:** sugar-candy
