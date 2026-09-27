-- WezTerm on Windows, mirroring kitty.conf. bootstrap-wsl.sh copies this to %USERPROFILE%\.wezterm.lua.
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- bootstrap-wsl.sh fills in the distro name ($WSL_DISTRO_NAME)
config.default_domain = 'WSL:__WSL_DISTRO__'

config.font = wezterm.font 'CaskaydiaCove Nerd Font'
config.font_size = 12.0
config.color_scheme = 'Catppuccin Mocha'

config.window_padding = { left = 12, right = 12, top = 12, bottom = 12 }
config.window_background_opacity = 0.8
config.win32_system_backdrop = 'Acrylic'
config.window_decorations = 'RESIZE'

config.default_cursor_style = 'BlinkingBlock'
config.scrollback_lines = 3000
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
  { key = 'n', mods = 'CTRL|SHIFT', action = act.SpawnWindow },
  { key = 't', mods = 'CTRL', action = act.SpawnTab 'DefaultDomain' },
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}
for i = 1, 9 do
  table.insert(config.keys, { key = tostring(i), mods = 'ALT', action = act.ActivateTab(i - 1) })
end

return config
