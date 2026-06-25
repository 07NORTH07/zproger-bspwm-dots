#!/bin/bash

#CURRENT_LAYOUT=$(xset -q|grep LED| awk '{ print $10 }')

#setxkbmap -layout us,ru -option "grp:alt_shift_toggle"
#if [ "$CURRENT_LAYOUT" = "00000000" ]; then
	#notify-send "Lang: US" -t 700
#fi

#if [ "$CURRENT_LAYOUT" = "00001000" ]; then
    #notify-send "Lang: RU" -t 700
#fi

#!/bin/bash

setxkbmap -layout us,ru,ua -option "grp:alt_shift_toggle"

#CURRENT=$(xkblayout-state print "%s")
CURRENT=$(/home/user/bin/xkblayout-state/xkblayout-state print "%s")

case "$CURRENT" in
    us) notify-send "Lang: US" -t 700 ;;
    ru) notify-send "Lang: RU" -t 700 ;;
    ua) notify-send "Lang: UA" -t 700 ;;
esac
