function p-hight --description 'Light gaming mode (sane limits, no throttling)'
    sudo auto-cpufreq --force=performance $argv
    sudo auto-cpufreq --turbo=auto
    brightnessctl set 100% 2>/dev/null
    rfkill unblock wifi
    rfkill unblock bluetooth
    echo "Performance mode: governor performance, turbo auto, brightness 100%, wifi/bt on"
end
