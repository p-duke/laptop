-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- helper: move while preserving "zoomed look"
local function move_preserve_zoom(dir)
	return wezterm.action_callback(function(window, pane)
		local tab = window:mux_window():active_tab()
		local zoomed = false
		if tab then
			for _, info in ipairs(tab:panes_with_info()) do
				if info.is_zoomed then
					zoomed = true
					break
				end
			end
		end

		if zoomed then
			window:perform_action(wezterm.action.TogglePaneZoomState, pane) -- unzoom
			window:perform_action(wezterm.action.ActivatePaneDirection(dir), pane) -- move
			window:perform_action(wezterm.action.TogglePaneZoomState, pane) -- re-zoom new pane
		else
			window:perform_action(wezterm.action.ActivatePaneDirection(dir), pane) -- normal move
		end
	end)
end

config = {
	-- Leader key setup: Ctrl + a (CapsLock remapped to Ctrl will trigger this)
	leader = { key = "s", mods = "CTRL", timeout_milliseconds = 5000 },
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	font_size = 16,
	tab_bar_at_bottom = true,
	show_tab_index_in_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	use_fancy_tab_bar = false,
	tab_max_width = 2000, -- 0 = no limit (can be very wide)
	unzoom_on_switch_pane = false,
	keys = {
		-- LEADER key
		{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

		-- Panes: match iTerm2 muscle memory
		{ key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- side-by-side
		{ key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) }, -- top/bottom

		-- Pane navigation with leader + hjkl (Vim-style)
		{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },

		-- Zoom current pane
		{ key = "Enter", mods = "CMD|SHIFT", action = wezterm.action.TogglePaneZoomState },

		-- Clear the terminal
		{ key = "r", mods = "CMD", action = wezterm.action.SendString("clear\n") },

		-- Cycle panes (Cmd+[ / ])
		{ key = "[", mods = "CMD", action = move_preserve_zoom("Prev") },
		{ key = "]", mods = "CMD", action = move_preserve_zoom("Next") },

		-- resize active pane with Leader + arrow keys ----
		{ key = "LeftArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 8 }) },
		{ key = "RightArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 8 }) },
		{ key = "UpArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 8 }) },
		{ key = "DownArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 8 }) },
		{
			key = "e",
			mods = "LEADER",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		-- Allow SHIFT+ENTER for Claude code
		-- { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
	},
}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end

	local pane_title = tab_info.active_pane.title
	-- If pane title includes "nvim", prefer directory instead
	if pane_title:match("nvim") then
		local cwd_uri = tab_info.active_pane:get_current_working_dir()
		if cwd_uri and cwd_uri.file_path then
			local path = cwd_uri.file_path
			local dir = path:match("([^/]+)/*$") or path
			return dir
		end
	end

	return pane_title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	if tab.is_active then
		return {
			{ Background = { Color = "blue" } },
			{ Text = " " .. title .. " " },
		}
	end
	if tab.is_last_active then
		-- Green color and append '*' to previously active tab.
		return {
			{ Background = { Color = "green" } },
			{ Text = " " .. title .. "*" },
		}
	end
	return title
end)

return config
