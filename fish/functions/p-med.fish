function p-med --description 'Reset to balanced/default mode'
    sudo auto-cpufreq --force=reset $argv
    sudo auto-cpufreq --turbo=auto
    brightnessctl set 70% 2>/dev/null
    echo "Balanced mode restored"
end
