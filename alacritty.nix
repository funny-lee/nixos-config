{
  pkgs,
  catppuccin-alacritty,
  ...
}:
###########################################################
#
# Alacritty Configuration
#
# Useful Hot Keys for macOS:
#   1. Multi-Window: `command + N`
#   2. Increase Font Size: `command + =` | `command + +`
#   3. Decrease Font Size: `command + -` | `command + _`
#   4. Search Text: `command + F`
#   5. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
#
# Useful Hot Keys for Linux:
#   1. Increase Font Size: `ctrl + shift + =` | `ctrl + shift + +`
#   2. Decrease Font Size: `ctrl + shift + -` | `ctrl + shift + _`
#   3. Search Text: `ctrl + shift + N`
#   4. And Other common shortcuts such as Copy, Paste, Cursor Move, etc.
#
# Note: Alacritty do not have support for Tabs, and any graphic protocol.
#
###########################################################
{
  xdg.configFile."alacritty/rose-pine-moon.toml".source = ./rose-pine-moon.toml;
  programs.alacritty = {
    enable = true;
  };

  xdg.configFile."alacritty/alacritty.toml".text =
''
import = ["~/.config/alacritty/rose-pine-moon.toml"]

[font]
size = 15

[font.bold]
family = "JetBrainsMono Nerd Font"

[font.bold_italic]
family = "JetBrainsMono Nerd Font"

[font.italic]
family = "JetBrainsMono Nerd Font"

[font.normal]
family = "JetBrainsMono Nerd Font"

[scrolling]
history = 10000

[shell]
program = "/run/current-system/sw/bin/zsh"

[window]
dynamic_title = true
opacity = 0.95
startup_mode = "Maximized"
'';
}
