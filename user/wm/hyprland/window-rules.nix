{...}:
{
  wayland.windowManager.hyprland.settings.windowrule = [
    # Smart gaps window rules (single tiled window)
    "border_size 0, match:float false, match:workspace w[tv1]"
    "rounding 0, match:float false, match:workspace w[tv1]"
    "border_size 0, match:float false, match:workspace f[1]"
    "rounding 0, match:float false, match:workspace f[1]"

    # Scratchpad rules - scratch_term (dropdown terminal)
    "float on, match:class ^(scratch_term)$"
    "size (monitor_w) (monitor_h*0.35), match:class ^(scratch_term)$"
    "move 0 0, match:class ^(scratch_term)$"
    "animation slide, match:class ^(scratch_term)$"
    "rounding 0, match:class ^(scratch_term)$"

    # Scratchpad rules - scratch_ranger
    "float on, match:class ^(scratch_ranger)$"
    "size (monitor_w*0.8) (monitor_h*0.85), match:class ^(scratch_ranger)$"
    "center on, match:class ^(scratch_ranger)$"

    # Scratchpad rules - scratch_thunar (only when on special workspace)
    "float on, match:class ^([Tt]hunar)$, match:workspace special:scratch_thunar"
    "size (monitor_w*0.8) (monitor_h*0.85), match:class ^([Tt]hunar)$, match:workspace special:scratch_thunar"
    "center on, match:class ^([Tt]hunar)$, match:workspace special:scratch_thunar"

    # Scratchpad rules - scratch_btm
    "float on, match:class ^(scratch_btm)$"
    "size (monitor_w*0.8) (monitor_h*0.85), match:class ^(scratch_btm)$"
    "center on, match:class ^(scratch_btm)$"

    # Save to Disk dialog
    "float on, match:title ^(Save to Disk)$"
    "size (monitor_w*0.7) (monitor_h*0.75), match:title ^(Save to Disk)$"
    "center on, match:title ^(Save to Disk)$"

    # Pavucontrol (centered in scratchpad)
    "float on, match:class ^(org.pulseaudio.pavucontrol)$"
    "size (monitor_w*0.6) (monitor_h*0.6), match:class ^(org.pulseaudio.pavucontrol)$"
    "center on, match:class ^(org.pulseaudio.pavucontrol)$"
    "opacity 0.90, match:class ^(org.pulseaudio.pavucontrol)$"

    # Miniframe (Emacs minibuffer)
    "float on, match:title \\*Minibuf.*"
    "size (monitor_w*0.64) (monitor_h*0.5), match:title \\*Minibuf.*"
    "move (monitor_w*0.18) (monitor_h*0.25), match:title \\*Minibuf.*"
    "animation popin, match:title \\*Minibuf.*"

    # XWayland video bridge
    "opacity 0.0, match:class ^(xwaylandvideobridge)$"
    "no_anim on, match:class ^(xwaylandvideobridge)$"
    "no_initial_focus on, match:class ^(xwaylandvideobridge)$"
    "max_size 1 1, match:class ^(xwaylandvideobridge)$"
    "no_blur on, match:class ^(xwaylandvideobridge)$"
    "no_focus on, match:class ^(xwaylandvideobridge)$"

    # Application-specific rules
    "float on, match:class ^(pokefinder)$"
    "opacity 0.80, match:title orui"
    "opacity 1.0, match:class ^(org.qutebrowser.qutebrowser), match:fullscreen true"
    "opacity 0.85, match:class ^(element)$"
    "opacity 0.85, match:class ^(lollypop)$"
    "opacity 1.0, match:class ^(brave-browser), match:fullscreen true"
    "opacity 1.0, match:class ^(librewolf), match:fullscreen true"
    "opacity 0.85, match:title ^(my local dashboard awesome homepage - qutebrowser)$"
    "opacity 0.85, match:title \\[.*\\] - my local dashboard awesome homepage"
    "opacity 0.85, match:class ^(org.keepassxc.keepassxc)$"
    "opacity 0.85, match:class ^(org.gnome.nautilus)$"

    # Group rules
    "group set, match:title codium"
    "group set, match:class firefox"
    "group set, match:class codium"

    # Flameshot rules
    "float on, match:class flameshot"
    "monitor 0, match:class flameshot"
    "move 0 0, match:class flameshot"
    "no_anim on, match:class flameshot"
    "rounding 0, match:class flameshot"

    # Comprehensive float rules
    "float on, match:title ^(Application Finder)$"
    "float on, match:title ^(Whisker Menu)$"
    "float on, match:title ^(Configure — Elisa)$"
    "float on, match:title ^(Add a new game)$"
    "float on, match:title ^(Add games to Lutris)$"
    "float on, match:title ^(Add New Items)$"
    "float on, match:class ^(xfce4-popup-whiskermenu)$"
    "float on, match:class ^(xfce4-terminal)$"
    "float on, match:title ^(Myuzi)$"
    "float on, match:title ^(scratchpad)$"
    "float on, match:class ^(gtkcord4)$"
    "float on, match:class ^(wrapper-2.0)$"
    "float on, match:class ^(gnome-calendar)$"
    "float on, match:title ^(steamwebhelper)$"
    "float on, match:class ^(.blueman-manager-wrapped)$"
    "float on, match:class ^(gnome-system-monitor)$"
    "float on, match:class ^(gnome-power-statistics)$"
    "float on, match:title ^(Application Launcher)$"
    "float on, match:class ^(Geary)$"
    "float on, match:class ^(Syncthing GTK)$"
    "float on, match:class ^(Proton Mail Bridge)$"
    "float on, match:class ^(Zenity)$"

    # Default float rules
    "float on, match:class ^(confirm)$"
    "float on, match:class ^(dialog)$"
    "float on, match:class ^(download)$"
    "float on, match:class ^(error)$"
    "float on, match:class ^(file_progress)$"
    "float on, match:class ^(notification)$"
    "float on, match:class ^(notify)$"
    "float on, match:class ^(popup_menu)$"
    "float on, match:class ^(splash)$"
    "float on, match:class ^(toolbar)$"
    "float on, match:class ^(confirmreset)$"
    "float on, match:class ^(makebranch)$"
    "float on, match:class ^(maketag)$"
    "float on, match:class ^(ssh-askpass)$"
    "float on, match:title ^(branchdialog)$"
    "float on, match:title ^(pinentry)$"

    # Additional system float rules
    "float on, match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
    "float on, match:class ^(nm-applet|nm-connection-editor)$"
    "float on, match:class ^(blueman-manager|blueman-applet)$"
    "float on, match:title ^(File Operation Progress|Progress)$"
    "float on, match:class ^(steam)$, match:title ^(Friends List|Steam Settings|Steam - News)$"
    "float on, match:class ^(discord|Discord)$, match:title ^(Discord Updater)$"
    "float on, match:class ^(firefox|librewolf)$, match:title ^(Picture-in-Picture|Extension: .*)$"
    "float on, match:class ^(pinentry-gtk-2|pinentry-qt)$"
    "float on, match:class ^(xfce4-appfinder|xfce4-notifyd)$"
    "float on, match:class ^(org.gnome.Nautilus|thunar)$, match:title ^(Open File|Save As)$"

    # Enhanced float settings
    "opacity 0.95, match:class ^(pinentry.*|dialog|notification)$"
    "size 600 400, match:class ^(pinentry.*|dialog)$"
    "float on, match:xwayland true, match:title ^(legacy popup)$"

    "float on, match:class ^(qt5ct)$"
    "float on, match:class ^(qt6ct)$"
    "float on, match:class ^(nvidia-settings)$"
    "float on, match:class ^(.*[Cc]alculator.*)$"
    "float on, match:class ^(.*color.*)$"
    "float on, match:class ^(.*[Gg]pick.*)$"
    "float on, match:class ^(.*file_progress.*)$"
    "float on, match:class ^(.*openfile.*)$"
    "float on, match:class ^(.*savefile.*)$"
    "float on, match:title ^(.*is sharing your screen.*)$"
  ];
}
