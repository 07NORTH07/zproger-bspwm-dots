╔══════════════════════════════════════════════════════════════════╗
║     ARCH LINUX — ThinkPad T14 Gen 1 AMD (Ryzen 7 PRO 5850U)    ║
║                   Полная инструкция установки                    ║
╚══════════════════════════════════════════════════════════════════╝


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  0. ПОДГОТОВКА
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Крупный шрифт (опционально, удобно на маленьком экране)
  pacman -S terminus-font
  setfont ter-u32b.psf.gz

# Проверяем сеть
  ping -c 3 archlinux.org


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. РАЗМЕТКА ДИСКА  (UEFI + GPT, без шифрования)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Сначала убеждаемся что диск — nvme0n1
  lsblk

  parted /dev/nvme0n1
    mklabel gpt
    mkpart ESP fat32 1MiB 512MiB
    set 1 boot on
    mkpart primary ext4 512MiB 100%
    quit

  Результат:
    /dev/nvme0n1p1  →  EFI/boot  (~512 МБ)
    /dev/nvme0n1p2  →  root      (~остаток диска)


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  2. ФОРМАТИРОВАНИЕ И МОНТИРОВАНИЕ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  mkfs.fat -F 32 /dev/nvme0n1p1
  mkfs.ext4 /dev/nvme0n1p2

  mount /dev/nvme0n1p2 /mnt
  mkdir /mnt/boot
  mount /dev/nvme0n1p1 /mnt/boot


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  3. УСТАНОВКА БАЗОВОЙ СИСТЕМЫ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  pacstrap -K /mnt \
    base linux linux-firmware base-devel \
    amd-ucode \
    mesa \
    xf86-video-amdgpu \
    vulkan-radeon \
    libva-mesa-driver \
    lvm2 \
    networkmanager \
    iwd \
    vim nano \
    efibootmgr \
    git python

  Пояснения:
    amd-ucode         — микрокод AMD, важен для стабильности
    mesa + xf86-video-amdgpu + vulkan-radeon — всё для Radeon Vega,
                        никаких проприетарных драйверов не нужно
    lvm2              — нужен для mkinitcpio даже без шифрования
    git python        — нужны сразу после ребута для клонирования Zproger


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  4. ГЕНЕРАЦИЯ FSTAB
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  genfstab -U /mnt >> /mnt/etc/fstab

# Обязательно проверяем — должны быть оба раздела
  cat /mnt/etc/fstab


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  5. НАСТРОЙКА СИСТЕМЫ (chroot)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  arch-chroot /mnt

  # --- Локали ---
  # Открываем и раскомментируем обе строки:
  #   en_US.UTF-8 UTF-8
  #   ru_RU.UTF-8 UTF-8
  nano /etc/locale.gen
  locale-gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf

  # --- Время (Украина) ---
  ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
  hwclock --systohc

  # --- Хостнейм ---
  echo "arch" > /etc/hostname

  # --- Пароль root ---
  passwd

  # --- Пользователь ---
  # ВАЖНО: имя обязательно "user" — Zproger хардкодит его в конфигах
  useradd -m -G wheel,users,video,audio,input -s /bin/bash user
  passwd user

  # --- Sudo ---
  # Раскомментировать строку: %wheel ALL=(ALL:ALL) ALL
  nano /etc/sudoers


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  6. MKINITCPIO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  nano /etc/mkinitcpio.conf

  Строка HOOKS должна быть такой (без encrypt и lvm2):

    HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck)

  mkinitcpio -p linux


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  7. ЗАГРУЗЧИК (systemd-boot)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  bootctl install

  # /boot/loader/loader.conf:
  nano /boot/loader/loader.conf
  ───────────────────────────
  default arch.conf
  timeout 3
  console-mode auto
  editor no
  ───────────────────────────

  # /boot/loader/entries/arch.conf:
  nano /boot/loader/entries/arch.conf
  ───────────────────────────────────
  title   Arch Linux
  linux   /vmlinuz-linux
  initrd  /amd-ucode.img
  initrd  /initramfs-linux.img
  options root=/dev/nvme0n1p2 rw quiet
  ───────────────────────────────────


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  8. ВКЛЮЧАЕМ СЛУЖБЫ И ПЕРЕЗАГРУЖАЕМСЯ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  systemctl enable NetworkManager
  systemctl enable iwd

  exit
  umount -R /mnt
  reboot

  ! Вытащи установочную флешку при перезагрузке !


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  9. ПОСЛЕ ПЕРВОГО ВХОДА
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Логинимся как user.

  # Обновляем систему
  sudo pacman -Syu

  # Устанавливаем yay (AUR хелпер — нужен для Zproger builder)
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd ~

  # Устанавливаем Xorg
  sudo pacman -S xorg xorg-xinit

  # Проверяем что AMD видит систему
  lspci | grep -i vga
  # Должно показать: AMD/ATI Renoir ...


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  10. УСТАНОВКА ОКРУЖЕНИЯ ZPROGER (bspwm dotfiles)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  git clone https://github.com/Zproger/bspwm-dotfiles.git
  cd bspwm-dotfiles

  # Смотрим список пакетов перед запуском
  # Nvidia/Intel пакеты не трогаем — AMD драйвера уже стоят
  nano Builder/packages.py

  python3 Builder/install.py

  В меню builder'а выбираем:
    [✓] Install dotfiles
    [✓] Update base
    [✓] Install BASE_PACKAGES
    [ ] DEV_PACKAGES — на своё усмотрение


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  11. ЕСЛИ ЯРКОСТЬ НЕ ОТОБРАЖАЕТСЯ НА БАРЕ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # Смотрим имя устройства подсветки
  ls /sys/class/backlight/
  # На T14 AMD обычно: amdgpu_bl1 или amdgpu_bl0

  # Правим модуль polybar
  nano ~/.config/polybar/modules.ini
  # Находим [module/backlight] → меняем card = amdgpu_bl1


━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  12. ЕСЛИ БАТАРЕЯ НЕ ОТОБРАЖАЕТСЯ НА БАРЕ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # Смотрим имя батареи
  ls /sys/class/power_supply/
  # Обычно: BAT0 или BAT1

  nano ~/bin/battery-alert
  # Меняем переменную battery на своё значение

  nano ~/.config/polybar/modules.ini
  # Правим [module/battery] — battery и adapter


══════════════════════════════════════════════════════════════════════
  Железо: ThinkPad T14 Gen 1 AMD | Ryzen 7 PRO 5850U | Radeon Vega
  Окружение: bspwm + polybar (Zproger dotfiles) | username: user
══════════════════════════════════════════════════════════════════════
