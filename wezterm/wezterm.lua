local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- 1. 別ファイルのキーバインドを一旦変数に入れる
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

local palette = {
	bg = "#0c1916",
	bg_deep = "#12302b",
	bg_soft = "#1c433b",
	bg_tab_bar = "#0f221e",
	bg_tab = "#2d564d",
	bg_tab_soft = "#397066",
	bg_tab_active = "#c8fff0",
	bg_tab_outline = "#d6fbf0",
	fg = "#eaf7f2",
	fg_strong = "#16312b",
	fg_muted = "#a9c9c0",
	fg_tab = "#e0f7f0",
	mint = "#7ff2cf",
	mint_bright = "#c2fff0",
	sage = "#7aa99c",
	line = "#4c8578",
	selection = "#2d6257",
	peach = "#f6c6bb",
}

config.font = wezterm.font_with_fallback({
	"Menlo",
	"Hiragino Maru Gothic ProN",
	"Symbols Nerd Font Mono",
	"Apple Color Emoji",
})
-- 2. リーダーキーの設定
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

-- 3. 画面分割などの「追加分」を既存の keys リストに加える
-- (これで keybinds.lua の内容を消さずに済みます)
table.insert(config.keys, {
	key = "v",
	mods = "LEADER",
	action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
})
-- ついでに水平分割 (Leader + h) も追加しておくと便利です
table.insert(config.keys, {
	key = "h",
	mods = "LEADER",
	action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
})

-- 4. 基本設定
config.disable_default_key_bindings = true
config.automatically_reload_config = true
config.font_size = 13.0
config.line_height = 1.08
config.window_padding = {
	left = 14,
	right = 14,
	top = 10,
	bottom = 10,
}
config.use_ime = true
config.window_background_opacity = 0.86
config.macos_window_background_blur = 24
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = true
config.adjust_window_size_when_changing_font_size = false
config.inactive_pane_hsb = {
	saturation = 0.92,
	brightness = 0.72,
}
config.colors = {
	foreground = palette.fg,
	background = palette.bg,
	cursor_bg = palette.mint_bright,
	cursor_fg = palette.bg,
	cursor_border = palette.mint_bright,
	selection_bg = palette.selection,
	selection_fg = palette.fg,
	scrollbar_thumb = palette.line,
	split = palette.line,
	ansi = {
		"#17312c",
		"#e38f9e",
		"#8ce5c8",
		"#e6d79c",
		"#8fb6d9",
		"#c7a7d9",
		"#91ece1",
		"#dceee7",
	},
	brights = {
		"#4a746b",
		"#f2a8b5",
		"#c2fff0",
		"#f2e5aa",
		"#b2d1ee",
		"#ddc0ec",
		"#c0fff4",
		"#f6fffb",
	},
	tab_bar = {
		background = palette.bg_tab_bar,
		inactive_tab_edge = "none",
		active_tab = {
			bg_color = palette.bg_tab_active,
			fg_color = palette.fg_strong,
		},
		inactive_tab = {
			bg_color = palette.bg_tab,
			fg_color = palette.fg_muted,
		},
		inactive_tab_hover = {
			bg_color = palette.bg_tab_soft,
			fg_color = palette.fg,
		},
		new_tab = {
			bg_color = palette.bg_tab,
			fg_color = palette.fg_muted,
		},
		new_tab_hover = {
			bg_color = palette.bg_tab_soft,
			fg_color = palette.fg,
		},
	},
}

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
	font = wezterm.font("Arial Rounded MT Bold"),
	font_size = 12.0,
}
config.window_background_gradient = {
	colors = { palette.bg, palette.bg_deep, "#2b6659" },
	orientation = { Linear = { angle = -20.0 } },
}
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 34

table.insert(config.keys, {
	key = "m",
	mods = "LEADER",
	action = act.EmitEvent("toggle-mint-opacity"),
})

-- 5. タブの外観設定
local ROUNDED_LEFT = utf8.char(0xe0b6)
local ROUNDED_RIGHT = utf8.char(0xe0b4)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = palette.bg_tab
	local foreground = palette.fg_tab
	local edge_background = palette.bg_tab_bar
	local left_edge_foreground = background
	local right_edge_foreground = background
	if tab.is_active then
		background = palette.bg_tab_active
		foreground = palette.fg_strong
		left_edge_foreground = background
		right_edge_foreground = background
	elseif hover then
		background = palette.bg_tab_soft
		foreground = palette.fg
	end
	local title = wezterm.truncate_right(tab.active_pane.title, max_width - 8)
	return {
		{ Background = { Color = edge_background } },
		{ Text = " " },
		{ Foreground = { Color = left_edge_foreground } },
		{ Text = ROUNDED_LEFT },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = "  " .. title .. "  " },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = right_edge_foreground } },
		{ Text = ROUNDED_RIGHT },
		{ Text = " " },
	}
end)

wezterm.on("toggle-mint-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.window_background_opacity == 0.94 then
		overrides.window_background_opacity = 0.86
		overrides.text_background_opacity = 1.0
	else
		overrides.window_background_opacity = 0.94
		overrides.text_background_opacity = 1.0
	end
	window:set_config_overrides(overrides)
end)

return config
