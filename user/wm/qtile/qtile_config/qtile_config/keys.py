from libqtile.lazy import lazy
from libqtile.config import Key, Group, Drag, Click, ScratchPad, DropDown
from functools import reduce
import operator

mod = "mod4"
terminal = "kitty"
backspace = 14
control = "control"
shift = "shift"
alt = "mod1"


@lazy.function
def switch_to_group_screen(qtile, groupname: str | None = None):
    # This shouldn't happen...
    if groupname is None:
        return
    group = qtile.groups_map[groupname]
    # if group is already on a screen...
    if group.screen:
        qtile.focus_screen(group.screen.index)
    # it's not on a screen
    else:
        group.cmd_toscreen()


def switch_group(group: Group):
    return Key(
        [mod],
        group.name,
        switch_to_group_screen(groupname=group.name),
        desc="Switch to group {}".format(group.name),
    )

    # return Key(
    #     [mod],
    #     group.name,
    #     lazy.group[group.name].toscreen(),
    #     desc=f"Switch to group {group.name}",
    # )


def move_window_and_switch_to_group(group: Group):
    return Key(
        [alt],
        group.name,
        lazy.window.togroup(group.name, switch_group=True),
        desc=f"Switch to & move focused window to group {group.name}",
    )


def move_window_to_group(group: Group):
    return Key(
        [mod, shift],
        group.name,
        lazy.window.togroup(group.name),
        desc="move focused window to group {}".format(group.name),
    )


switch_windows = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(
        [mod], "backspace", lazy.layout.next(), desc="Move window focus to other window"
    ),
]

shuffle_windows = [
    Key([mod, shift], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key(
        [mod, shift],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, shift], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, shift], "k", lazy.layout.shuffle_up(), desc="Move window up"),
]

grow_window = [
    Key([mod, control], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, control], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, control], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, control], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
]

workspaces = [Group(str(i)) for i in range(1, 10)]
workspaces_keys = reduce(
    operator.add,
    map(lambda group: [switch_group(group), move_window_to_group(group)], workspaces),
)

scratchpads = [
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                "alacritty --class scratch",
                width=0.8,
                height=0.8,
                x=0.1,
                y=0.1,
                opacity=0.9,
            ),
            DropDown(
                "ranger",
                "alacritty --class=ranger -e ranger",
                width=0.8,
                height=0.8,
                x=0.1,
                y=0.1,
                opacity=0.9,
            ),
            DropDown(
                "volume",
                "pavucontrol",
                width=0.8,
                height=0.8,
                x=0.1,
                y=0.1,
                opacity=0.9,
            ),
            DropDown(
                "thunar", "thunar", width=0.8, height=0.8, x=0.1, y=0.1, opacity=1
            ),
        ],
    )
]
groups = workspaces + scratchpads

scratchpads_keys = [
    Key(
        [mod],
        "g",
        lazy.group["scratchpad"].dropdown_toggle("term"),
        desc="Launch terminal",
    ),
    Key(
        [mod],
        "r",
        lazy.group["scratchpad"].dropdown_toggle("ranger"),
        desc="Launch ranger",
    ),
    Key(
        [mod],
        "b",
        lazy.group["scratchpad"].dropdown_toggle("volume"),
        desc="Launch pavucontrol",
    ),
    Key(
        [mod],
        "e",
        lazy.group["scratchpad"].dropdown_toggle("thunar"),
        desc="Launch thunar",
    ),
]


launch_programs = [
    Key([mod], "t", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "m", lazy.spawn("thunderbird --name thunderbird"), desc="Launch Mail (Thunderbird)"),
    Key(
        [mod, shift],
        "t",
        lazy.spawn("xfce4-terminal --drop-down"),
        desc="Launch terminal",
    ),
    Key([mod], "grave", lazy.spawn("firefox"), desc="Launch firefox"),
    Key([mod], "o", lazy.spawn("obsidian"), desc="Launch obsidian"),
    Key(
        [mod],
        "semicolon",
        lazy.spawn("xfce4-appfinder"),
        desc="Launch xfce's app-finder",
    ),
    Key(
        [mod],
        "escape",
        lazy.spawn("xfce4-session-logout"),
        desc="Launch logout options",
    ),
    Key([mod], "s",
        lazy.spawn("maim -s | xclip -selection clipboard -t image/png"),
        desc="Select an area on screen, then copy the selection to clipboard"
    ),
]

layouts_control = [
    Key(
        [mod, shift],
        "s",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, shift], "Tab", lazy.prev_layout(), desc="Toggle between layouts"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "space",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    # Key([mod], "m", lazy.layout.maximize(), desc="use max layout"),
    Key(
        [mod],
        "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod],
        "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the right",
    ),
]


control_keys = [
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, control], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, control], "x", lazy.restart(), desc="Restart Qtile"),
    Key([mod, control], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "x", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl set +10"),
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl set 10-"),
    ),
    Key([], "xF86AudioLowerVolume", lazy.spawn("pamixer -d 10")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 10")),
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t")),
]
# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
virtual_terminals_wayland = [
    Key(
        [control, alt],
        f"f{vt}",
        lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
        desc=f"Switch to VT{vt}",
    )
    for vt in range(1, 8)
]

keys = [
    *switch_windows,
    *shuffle_windows,
    *grow_window,
    *workspaces_keys,
    *scratchpads_keys,
    *launch_programs,
    *layouts_control,
    *control_keys,
    *virtual_terminals_wayland,
]

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
