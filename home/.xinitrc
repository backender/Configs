########################################################################
#
# ~/.xinitrc
# Startet Windowmanager
#
########################################################################

########################################################################
# Variabeln
DEFAULT_SESSION=openbox

########################################################################
# Main

# Session setzen
if [ -z "$1" ]
then
  SESSION="$DEFAULT_SESSION"
else
  SESSION="$1"
fi

# Weitere xinitrc-Dateien ausführen
if [ -d /etc/X11/xinit/xinitrc.d ]
then
  for f in /etc/X11/xinit/xinitrc.d/*
  do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# SSH-Agent
eval `ssh-agent`
urxvt -fn "xft:Bitstream Vera Sans Mono:pixelsize=23" \
  -bg red -fg black -geometry 80x4 -e sh -c "ssh-add"

# GPG-Agent
eval `gpg-agent --daemon`

# Programme starten
xmodmap ~/.xmodmaprc
xbindkeys &
(sleep 1;
urxvt -e tmux &
eval `cat ~/.fehbg`;
# xcompmgr -c -r 20 &
# conky &
# conky -c ~/.conkyrc_stundenplan &
keepassx -min -lock &
volwheel &
pidgin &
# redshift -l 47.22:8.33 -b 1.0
) &

# Windowmanager starten
case $SESSION in
awesome|fluxbox|icewm|i3|dwm|wmii|fvwm|twm|wmfs)
  exec ck-launch-session $1
  ;;
openbox)
  tint2 &
  exec openbox-session
  ;;
esac

#EOF
