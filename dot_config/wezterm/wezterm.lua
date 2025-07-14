local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.automatically_reload_config = true

font = wezterm.font('HackGen Console NFJ')
config.font_size = 18.0
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'
config.show_tabs_in_tab_bar = false
config.disable_default_key_bindings = true


return config
