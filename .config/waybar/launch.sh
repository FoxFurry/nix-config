#!/usr/bin/env bash
#
#        ______           ______
#       / ____/___  _  __/ ____/_  ______________  __
#      / /_  / __ \| |/_/ /_  / / / / ___/ ___/ / / /
#     / __/ / /_/ />  </ __/ / /_/ / /  / /  / /_/ /
#    /_/    \____/_/|_/_/    \__,_/_/  /_/   \__, /
#                                           /____/

killall waybar

waybar -c $HOME/.config/waybar/waybar.conf -s $HOME/.config/waybar/style.css
