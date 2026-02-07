{...}:
let
  dropdownsize = "size 100% 35%";
  scratchpadsize = "size 80% 85%";
  scratch_term = "class:^(scratch_term)$";
  scratch_ranger = "class:^(scratch_ranger)$";
  scratch_thunar = "class:^(scratch_thunar)$";
  scratch_btm = "class:^(scratch_btm)$";
  miniframe = "title:\*Minibuf.*";
  savetodisk = "title:^(Save to Disk)$";
  pavucontrol = "class:^(org.pulseaudio.pavucontrol)$";
in
{
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    # Scratchpad rules
    "float,${scratch_term}"
    "${dropdownsize},${scratch_term}"
    "move 0% 0%,${scratch_term}"
    "animation slidevert,${scratch_term}"

    "float,${scratch_ranger}"
    "${scratchpadsize},${scratch_ranger}"
    "center,${scratch_ranger}"

    "float,${scratch_thunar}"
    "${scratchpadsize},${scratch_thunar}"
    "center,${scratch_thunar}"

    "float,${scratch_btm}"
    "${scratchpadsize},${scratch_btm}"
    "center,${scratch_btm}"

    "float,${savetodisk}"
    "size 70% 75%,${savetodisk}"
    "center,${savetodisk}"

    "float,${pavucontrol}"
    "size 86% 40%,${pavucontrol}"
    "move 50% 6%,${pavucontrol}"
    "workspace special silent,${pavucontrol}"
    "opacity 0.80,${pavucontrol}"

    "float,${miniframe}"
    "size 64% 50%,${miniframe}"
    "move 18% 25%,${miniframe}"
    "animation popin 1 20,${miniframe}"
    # xwayland window rules
    "opacity 0.0 override, class:^(xwaylandvideobridge)$"
    "noanim, class:^(xwaylandvideobridge)$"
    "noinitialfocus, class:^(xwaylandvideobridge)$"
    "maxsize 1 1, class:^(xwaylandvideobridge)$"
    "noblur, class:^(xwaylandvideobridge)$"
    "nofocus, class:^(xwaylandvideobridge)$"
    # Application-specific rules
    "float,class:^(pokefinder)$"
    "opacity 0.80,title:orui"
    "opacity 1.0,class:^(org.qutebrowser.qutebrowser),fullscreen:1"
    "opacity 0.85,class:^(element)$"
    "opacity 0.85,class:^(lollypop)$"
    "opacity 1.0,class:^(brave-browser),fullscreen:1"
    "opacity 1.0,class:^(librewolf),fullscreen:1"
    "opacity 0.85,title:^(my local dashboard awesome homepage - qutebrowser)$"
    "opacity 0.85,title:\[.*\] - my local dashboard awesome homepage"
    "opacity 0.85,class:^(org.keepassxc.keepassxc)$"
    "opacity 0.85,class:^(org.gnome.nautilus)$"

    # Group rules
    "group, title:codium"
    "group, class:firefox"
    "group, class:codium"

    # Flameshot rules
    "float,class:flameshot"
    "monitor 0,class:flameshot"
    "move 0 0,class:flameshot"
    "noanim,class:flameshot"
    "noborder,class:flameshot"
    "rounding 0,class:flameshot"

    # Comprehensive float rules
    "float,title:^(Application Finder)$"
    "float,title:^(Whisker Menu)$"
    "float,title:^(Configure — Elisa)$"
    "float,title:^(Add a new game)$"
    "float,title:^(Add games to Lutris)$"
    "float,title:^(Add New Items)$"
    "float,class:^(xfce4-popup-whiskermenu)$"
    "float,class:^(xfce4-terminal)$"
    "float,title:^(Myuzi)$"
    "float,title:^(scratchpad)$"
    "float,class:^(gtkcord4)$"
    "float,class:^(wrapper-2.0)$"
    "float,class:^(gnome-calendar)$"
    "float,title:^(steamwebhelper)$"
    "float,class:^(.blueman-manager-wrapped)$"
    # "float,class:^(pavucontrol)$"
    "float,class:^(gnome-system-monitor)$"
    "float,class:^(gnome-power-statistics)$"
    "float,title:^(Application Launcher)$"
    "float,class:^(Geary)$"
    # "float,class:^(Pavucontrol)$"
    "float,class:^(Syncthing GTK)$"
    "float,class:^(Proton Mail Bridge)$"
    "float,class:^(Zenity)$"

    # Default float rules
    "float,class:^(confirm)$"
    "float,class:^(dialog)$"
    "float,class:^(download)$"
    "float,class:^(error)$"
    "float,class:^(file_progress)$"
    "float,class:^(notification)$"
    "float,class:^(notify)$"
    "float,class:^(popup_menu)$"
    "float,class:^(splash)$"
    "float,class:^(toolbar)$"
    "float,class:^(confirmreset)$"
    "float,class:^(makebranch)$"
    "float,class:^(maketag)$"
    "float,class:^(ssh-askpass)$"
    "float,title:^(branchdialog)$"
    "float,title:^(pinentry)$"

    # Additional system float rules
    "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
    "float,class:^(nm-applet|nm-connection-editor)$"
    "float,class:^(blueman-manager|blueman-applet)$"
    "float,title:^(File Operation Progress|Progress)$"
    "float,class:^(steam)$,title:^(Friends List|Steam Settings|Steam - News)$"
    "float,class:^(discord|Discord)$,title:^(Discord Updater)$"
    "float,class:^(firefox|librewolf)$,title:^(Picture-in-Picture|Extension: .*)$"
    "float,class:^(pinentry-gtk-2|pinentry-qt)$"
    "float,class:^(xfce4-appfinder|xfce4-notifyd)$"
    "float,class:^(org.gnome.Nautilus|thunar)$,title:^(Open File|Save As)$"

    # Enhanced float settings
    "opacity 0.95,class:^(pinentry.*|dialog|notification)$"
    # "center,class:^(pinentry.*|pavucontrol|notification)$"
    "size 600 400,class:^(pinentry.*|dialog)$"
    "float,xwayland:1,title:^(legacy popup)$"

    "float,class:^(qt5ct)$"
    "float,class:^(qt6ct)$"
    "float,class:^(nvidia-settings)$"
    "float,class:^(.*[Cc]alculator.*)$"
    "float,class:^(.*color.*)$"
    "float,class:^(.*[Gg]pick.*)$"
    "float,class:^(.*file_progress.*)$"
    "float,class:^(.*openfile.*)$"
    "float,class:^(.*savefile.*)$"
    "float, title:^(.*is sharing your screen.*)$"
  ];
}
