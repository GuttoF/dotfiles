local wezterm = require 'wezterm'

local config = wezterm.config_builder()
config.font = wezterm.font('MesloLGM Nerd Font')
config.font_size = 14

config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'

config.color_scheme = 'Material Palenight (base16)'
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

config.inactive_pane_hsb = {saturation = 0.24, brightness = 0.5}

config.status_update_interval = 1000
config.tab_bar_at_bottom = true

config.keys = {
  -- Create new tab with Ctrl + T
  {key="t", mods="CTRL", action=wezterm.action{SpawnTab="DefaultDomain"}},
  {key="1", mods="CTRL", action=wezterm.action{ActivateTab=0}},
  {key="2", mods="CTRL", action=wezterm.action{ActivateTab=1}},
  {key="3", mods="CTRL", action=wezterm.action{ActivateTab=2}},
  {key="4", mods="CTRL", action=wezterm.action{ActivateTab=3}},
  {key="5", mods="CTRL", action=wezterm.action{ActivateTab=4}},
  {key="6", mods="CTRL", action=wezterm.action{ActivateTab=5}},
  {key="7", mods="CTRL", action=wezterm.action{ActivateTab=6}},
  {key="8", mods="CTRL", action=wezterm.action{ActivateTab=7}},
  {key="9", mods="CTRL", action=wezterm.action{ActivateTab=8}},
  {key="q", mods="CTRL", action="QuitApplication"},
  {key="/", mods="CTRL", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
  {key="\\", mods="CTRL", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
  -- Close split pane with Ctrl + E
  {key="e", mods="CTRL", action=wezterm.action{CloseCurrentPane={confirm=false}}},
}


return config

