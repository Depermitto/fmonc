import psutil, iwlib, os, subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


@hook.subscribe.startup_complete
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])


mod = "mod4"
terminal = guess_terminal()

keys = [
    # My custom keybindings
    Key([mod], "d", lazy.spawn("dmenu_run")),
    Key([mod], "r", lazy.spawn("rofi -show drun")),
    Key([mod, "shift"], "d", lazy.spawn("networkmanager_dmenu")),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on current window"),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "control"], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # LAPTOP KEYS

    # Change volume
    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn('pamixer -i 5')
    ),

    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn('pamixer -d 5')
    ),

    Key(
        [], "XF86AudioMute",
        lazy.spawn('pamixer -t')
    ),

    # Change Brightness
    Key(
        [], "XF86MonBrightnessUp",
        lazy.spawn('brightnessctl set +5%')
    ),

    Key(
        [], "XF86MonBrightnessDown",
        lazy.spawn('brightnessctl set 5%-')
    ),
]


## CUSTOM WORKSPACE NAMES
Workspaces = ['M1', 'M2', 'Dev', 'Sys', 'Net', 'Work']

groups = [Group(str(i + 1), label=Workspaces[i]) for i in range(len(Workspaces))]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )


# Colors
def init_colors():
    return [['#1F232E', '#1F232E'], # bar color
            ['#2d6296', '#2d6296'], # focused windows border color
            ['#484E69', '#484E69'], # inactive group color
            ['#2B2F40', '#2B2F40']] # inactive screen color
colors = init_colors()


layouts = [
    # layout.MonadTall(border_focus=colors[1], border_width=2),
    layout.Columns(border_focus=colors[1], border_width=2),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='sans',
    fontsize=14,
    padding=2,
)
extension_defaults = widget_defaults.copy()
screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    highlight_method='block',
                    urgent_alert_method='block',
                    urgent_text='FFFFFF',
                    this_current_screen_border=colors[1],
                    this_screen_border=colors[1],
                    other_current_screen_border=colors[3],
                    other_screen_border=colors[3],
                    inactive=colors[2],
                    disable_drag=True,
                    fontsize=15,
                    padding=7,
                ),
                widget.TextBox(
                    '[',
                    padding=0,
                ),
                widget.CurrentLayout(
                    padding=0,
                ),
                widget.TextBox(
                    ']',
                    padding=0,
                ),
                widget.WindowName(
                    max_chars=20,
                    padding=10,
                ),

                # CPU
                widget.TextBox(
                    '',
                    fontsize=17,
                    padding=0,
                ),
                widget.CPU(
                    format='CPU: {load_percent}%'
                ),
                widget.TextBox(
                    padding=1
                ),

                # RAM Memory Usage
                widget.TextBox(
                    '',
                    fontsize=17,
                    padding=0,
                ),
                widget.Memory(
                    format='MEM: {MemUsed:.1f}{mm}',
                    measure_mem='G'
                ),
                widget.TextBox(
                    padding=1
                ),

                # Volume
                widget.TextBox(
                    '',
                    fontsize=17,
                    padding=0,
                ),
                widget.PulseVolume(
                    get_volume_command='pamixer --get-volume',
                    update_interval=0,
                ),
                widget.TextBox(
                    padding=1
                ),

                # Brightness
                widget.TextBox(
                    '',
                    fontsize=17,
                    padding=0,
                ),
                widget.Backlight(
                    backlight_name='intel_backlight',
                    brightness_file='actual_brightness',
                    update_interval=0,
                ),
                widget.TextBox(
                    padding=1
                ),

                # Battery
                widget.TextBox(
                    '',
                    fontsize=17,
                    padding=0,
                ),
                widget.Battery(
                    format='{percent:2.0%}',
                ),
                widget.TextBox(
                    padding=1
                ),

                # Wifi
                widget.TextBox(
                    '',
                    fontsize=17,
                    padding=0,
                ),
                widget.Wlan(
                    max_chars=6,
                    format='{essid}'
                ),
                widget.TextBox(
                    padding=1
                ),

                # Calendar
                widget.TextBox(
                    '',
                    fontsize=17,
                    padding=0,
                ),
                widget.Clock(
                    format='%d/%m/%y'
                ),
                widget.TextBox(
                    padding=1
                ),

                # Clock
                widget.TextBox(
                    '',
                    fontsize=17,
                    padding=0,
                ),
                widget.Clock(
                    format='%H:%M:%S',
                ),

            ],
            28,
            background=colors[0],
            opacity=0.5,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        wallpaper='~/Pictures/dark_planks.jpg',
        wallpaper_mode='stretch',
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
