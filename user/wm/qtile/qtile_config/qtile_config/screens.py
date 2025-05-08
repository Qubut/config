from libqtile import bar, widget
from libqtile.lazy import lazy
from libqtile.widget import backlight  # For brightness control

rofi_command = r'''
rofi -theme sidebar -show drun \
  -modi drun,run \
  -show-icons \
  -icon-theme "Papirus-Dark" \
  -drun-display-format "{name} <span weight='light' size='small'>({generic})</span>" \
  -markup-rows \
  -kb-row-select "Control+space" \
  -i \
  -sorting-method "fzf" \
  -hover-select \
  -me-accept-entry "MousePrimary" \
  -me-select-entry "MouseSecondary"
'''

def init_widgets_list(colors):
    left_side_widgets = [
        widget.TextBox(
            text="  ",
            foreground=colors["cyan"],
            padding=8,
            fontsize=24,
            mouse_callbacks={"Button1": lazy.spawn(rofi_command)},
        ),
        widget.Sep(linewidth=0, padding=6),
        widget.GroupBox(
            font="FontAwesome",
            fontsize=18,
            margin_y=3,
            padding_x=5,
            borderwidth=2,
            active=colors["bright_white"],
            inactive=colors["bright_black"],
            rounded=False,
            highlight_method="line",
            highlight_color=[colors["background"], colors["background"]],
            this_current_screen_border=colors["blue"],
            urgent_border=colors["red"],
            disable_drag=True,
        ),
        widget.Sep(linewidth=0, padding=6),
        widget.CPU(
            format="󰍛 {load_percent}%",
            foreground=colors["blue"],
            update_interval=2,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        widget.CPUGraph(
            graph_color=colors["blue"],
            fill_color=colors["blue"] + ".3",
            border_color=colors["background"],
            samples=100,
            width=30,
        ),
        widget.Memory(
            format=" {MemUsed: .0f}{mm}",
            measure_mem="G",
            foreground=colors["magenta"],
            update_interval=2,
        ),
        widget.MemoryGraph(
            graph_color=colors["magenta"],
            fill_color=colors["magenta"] + ".3",
            width=30,
        ),
        widget.NvidiaSensors(
            format="󰍟 {temp}°C | 󰈐 {fan_speed}% | 󰣇 {perf}",
            foreground=colors["cyan"],
            foreground_alert=colors["red"],
            threshold=80,
            update_interval=2,
            mouse_callbacks={
                "Button1": lazy.spawn("nvidia-settings"),
                "Button3": lazy.spawn("gnome-system-monitor"),
            },
        ),
        widget.ThermalSensor(
            foreground=colors["red"],
            threshold=80,
            fmt=" {}",
            update_interval=5,
            mouse_callbacks={"Button1": lazy.spawn("gnome-system-monitor")},
        ),
        # widget.Net(
        #     interface="all",
        #     format="󰈀 {down} ↓↑ {up}",
        #     foreground=colors["green"],
        #     update_interval=1,
        #     mouse_callbacks={"Button1": lazy.spawn("nm-connection-editor")},
        # ),
        widget.NetGraph(
            interface="auto",
            bandwidth_type="down",
            type="linefill",
            graph_color=colors["green"],
            fill_color=colors["green"] + ".3",  # 30% transparency
            border_color=colors["background"],
            line_width=2,
            margin_x=5,
            samples=100,
            update_interval=1.0,
        ),
        # widget.Battery(
        #     format="{char} {percent:2.0%} {hour:d}:{min:02d}",
        #     charge_char="",
        #     discharge_char="",
        #     full_char="",
        #     unknown_char="",
        #     low_percentage=0.15,
        #     low_foreground=colors["red"],
        #     foreground=colors["green"],
        #     update_interval=60,
        # ),
        # widget.BatteryIcon(
        #     padding=0,
        #     scale=1.2,
        #     mouse_callbacks={"Button1": lazy.spawn("gnome-power-statistics")},
        # ),
        widget.WindowName(
            foreground=colors["bright_blue"],
            max_chars=60,
            fontsize=14,
            format=" {name} ",
        ),
    ]

    center_widgets = [
        widget.Spacer(length=bar.STRETCH),
        widget.TaskList(
            highlight_method="block",
            icon_size=16,
            max_title_width=200,
            rounded=False,
            padding=3,
            margin=2,
            border=colors["blue"],
            urgent_border=colors["red"],
            txt_floating="🗗 ",
            txt_maximized="🗖 ",
            txt_minimized="🗕 ",
        ),
        widget.Spacer(length=bar.STRETCH),
    ]

    right_side_widgets = [
        widget.Volume(
            fmt="󰕾 {}",
            foreground=colors["yellow"],
            padding=5,
            mouse_callbacks={
                "Button1": lazy.spawn("pavucontrol"),
                "Button3": lazy.spawn("amixer -q set Master toggle"),
            },
        ),
        widget.PulseVolume(
            fmt="󰕾 {}",
            foreground=colors["yellow"],
            limit_max_volume=True,
            mouse_callbacks={"Button1": lazy.spawn("pavucontrol")},
        ),
        # widget.Backlight(
        #     fmt="󰛨 {}",
        #     foreground=colors["cyan"],
        #     # backlight_name="intel_backlight",  # Change according to your system
        #     change_command="brightnessctl set {0}%",
        #     step=5,
        #     mouse_callbacks={
        #         "Button4": lazy.widget["backlight"].change_backlight(
        #             backlight.ChangeDirection.UP
        #         ),
        #         "Button5": lazy.widget["backlight"].change_backlight(
        #             backlight.ChangeDirection.DOWN
        #         ),
        #     },
        # ),
        widget.DF(
            fmt=" {}",
            foreground=colors["magenta"],
            visible_on_warn=False,
            warn_color=colors["red"],
            warn_space=20,
            format="{p} {uf}{m} ({r:.0f}%)",
            update_interval=60,
            mouse_callbacks={"Button1": lazy.spawn("baobab")},
        ),
        widget.Clipboard(
            fmt="󰋢 {} ",  # Use a clipboard icon from your font (e.g., 󰋢 from NerdFonts)
            max_chars=15,  # Truncate after 15 characters
            timeout=10,  # Hide sensitive content after 10 seconds
            blacklist=["keepassx", "bitwarden"],  # Add your password managers here
            selection="CLIPBOARD",  # Use the standard clipboard (not primary selection)
            foreground=colors["yellow"],  # Match your color scheme
            scroll=True,  # Enable scrolling for long content
            scroll_step=2,
            scroll_interval=0.05,
            mouse_callbacks={
                "Button1": lazy.spawn(
                    "xclip -o -selection clipboard | xsel --clipboard --input"
                ),
                "Button3": lazy.spawn("xsel --clear --clipboard"),
            },
        ),
        widget.Sep(linewidth=0, padding=6),
        widget.KeyboardKbdd(
            configured_keyboards=["eu", "ar", "ru", "tr"],
            colours=[colors["blue"], colors["red"], colors["green"], colors["yellow"]],
            fmt="󰌌 {}",
            foreground=colors["foreground"],
            update_interval=0.5,
            mouse_callbacks={
                "Button1": lazy.widget["keyboardkbdd"].next_keyboard(),
            },
        ),
        widget.Sep(linewidth=0, padding=6),
        widget.Systray(
            icon_size=20,
            padding=5,
        ),
        widget.Sep(linewidth=0, padding=6),
        widget.Clock(
            format=" %H:%M |  %a %d-%m-%Y",
            foreground=colors["blue"],
            mouse_callbacks={"Button1": lazy.spawn("gnome-calendar")},
        ),
        widget.QuickExit(
            default_text="⏻",
            countdown_format="[{}s]",
            foreground=colors["red"],
            padding=10,
            timer_interval=1,
        ),
        widget.Sep(linewidth=0, padding=6),
    ]

    widgets_list = left_side_widgets + center_widgets + right_side_widgets
    return widgets_list
