from libqtile import layout
from libqtile.config import Drag, Group, Key, Match, Screen, ScratchPad

layouts = [
    layout.MonadTall(ratio=0.56, single_border_width=0, single_margin=9, margin=9),
    layout.Max(),
    layout.TreeTab(border_width=0),
    layout.Zoomy(),
    layout.Stack(num_stacks=2),
]


floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        Match(title="Application Finder"),
        Match(title="Whisker Menu"),
        Match(title="Configure — Elisa"),
        Match(title="Add a new game"),
        Match(title="Add games to Lutris"),
        Match(title="Add New Items"),
        Match(wm_instance_class="xfce4-popup-whiskermenu"),
        Match(wm_instance_class="xfce4-terminal"),
        Match(title="Myuzi"),
        Match(title="scratchpad"),
        Match(wm_class="gtkcord4"),
        Match(wm_class="wrapper-2.0"),
        Match(wm_class="gnome-calendar"),
        Match(title="steamwebhelper"),
        Match(wm_class=".blueman-manager-wrapped"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="gnome-system-monitor"),
        Match(wm_class="gnome-power-statistics"),
        Match(title="Application Launcher"),
        Match(wm_class="Geary"),
        Match(wm_class="Pavucontrol"),
        Match(wm_class="Syncthing GTK"),
        Match(wm_class="Proton Mail Bridge"),
        Match(wm_class="Zenity"),
        *layout.Floating.default_float_rules,
        Match(wm_class="confirm"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class="notification"),
        Match(wm_class="notify"),
        Match(wm_class="popup_menu"),
        Match(wm_class="splash"),
        Match(wm_class="toolbar"),
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
