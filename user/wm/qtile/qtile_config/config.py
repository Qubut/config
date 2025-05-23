from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import os
import subprocess
from libqtile import hook
import operator
from qtile_config.screens import init_widgets_list
from qtile_config.keys import keys, mouse, groups
from qtile_config.layouts import layouts, floating_layout
from qtile_config.hooks import *
from colors import colors

screens = [
    Screen(
        bottom=bar.Bar(
            widgets=init_widgets_list(colors),
            size=30,
            margin=[3, 7, 7, 7],  # N E S W
            background=colors["background"],
            opacity=0.94,
        ),
    ),
]


extension_defaults = dict(
    font="FontAwesome, Noto Sans",
    fontsize=16,
    padding=5,
    background=colors["background"],
    foreground=colors["foreground"],
)

# Drag floating layouts.
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
