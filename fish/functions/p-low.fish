function p-low --description 'Max battery saving mode for long trips'
    sudo auto-cpufreq --force=powersave $argv
    sudo auto-cpufreq --turbo=never
    brightnessctl set 30% 2>/dev/null
    echo "Powersave mode: CPU+turbo off, brightness 30%"
end
