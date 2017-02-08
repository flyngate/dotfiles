xset +fp ~/.fonts
xset fp rehash
setxkbmap us,ru -option grp:alt_shift_toggle

function exec_bspwm {
  #hsetroot -fill ~/wallpaper-191561.jpg
  hsetroot -solid "#111111"
  xsetroot -cursor_name left_ptr
  sxhkd -f 100 &
  compton &
  PATH="$PATH:$HOME/.config/bspwm/panel";PANEL_FIFO="/tmp/panel-fifo" panel &
  exec bspwm
}

exec_bspwm

