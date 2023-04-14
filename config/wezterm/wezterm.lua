local wezterm = require("wezterm")
local scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local home_dir = wezterm.home_dir

  if pane.domain_name == "dkfz-workstation" or pane.domain_name == "E290-PC05" then
    home_dir = "/home/t974t"
  end

  local title = string.gsub(pane.current_working_dir, home_dir, "~")
  title = string.gsub(title, "~/Projects", "~p")
  title = string.gsub(title, "file://", "")
  title = pane.title .. " - " .. title
  title = wezterm.truncate_right(title, max_width - 4)
  title = title
  return wezterm.format({
    { Background = { Color = scheme.tab_bar.background } },
    { Text = " " },
    "ResetAttributes",
    { Attribute = { Italic = true } },
    { Attribute = { Intensity = "Bold" } },
    { Text = " " },
    { Text = title },
    { Text = " " },
    { Background = { Color = scheme.tab_bar.background } },
    { Text = " " },
  })
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  return tab.active_pane.title .. " (" .. tab.active_pane.domain_name .. ")"
end)

wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(wezterm.format({
    { Foreground = { AnsiColor = "Blue" } },
    { Attribute = { Intensity = "Bold" } },
    { Text = pane:get_domain_name() },
  }))
end)

local function get_font_size()
  local res, screens = pcall(wezterm.gui.screens)
  local active_screen = nil
  if res then
    active_screen = screens.active.name
  end
  if active_screen == "Built-in Retina Display" or wezterm.hostname() == "deep-thought" then
    return 14
  else
    return 18
  end
end

wezterm.on("window-focus-changed", function(window, pane)
  if not window:is_focused() then
    return
  end

  local overrides = window:get_config_overrides() or {}

  local font_size = get_font_size()

  if overrides.font_size and overrides.font_size == font_size then
    return
  end

  overrides.font_size = font_size
  window:set_config_overrides(overrides)
end)

return {
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font("VictorMono Nerd Font"),
  font_size = get_font_size(),
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  tab_max_width = 32,
  term = "wezterm",

  command_palette_bg_color = "#11111b",
  command_palette_fg_color = "#cdd6f4",
  command_palette_font_size = 18,

  -- NOTE: This is for ssh agent forwarding
  unix_domains = {
    {
      name = "dkfz-workstation",
      local_echo_threshold_ms = 150,
      proxy_command = { "/usr/bin/ssh", "-T", "dkfz-workstation", "wezterm", "cli", "proxy" },
    },
  },

  leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    {
      key = " ",
      mods = "LEADER",
      action = wezterm.action.ActivateCommandPalette,
    },
    {
      key = "s",
      mods = "LEADER",
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "v",
      mods = "LEADER",
      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "f",
      mods = "LEADER",
      action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS|DOMAINS|LAUNCH_MENU_ITEMS" }),
    },
    {
      key = "t",
      mods = "LEADER",
      action = wezterm.action.SpawnCommandInNewTab({ domain = "CurrentPaneDomain", cwd = "~" }),
    },
    {
      key = "T",
      mods = "LEADER",
      action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "Enter",
      mods = "LEADER",
      action = wezterm.action.SpawnCommandInNewWindow({ domain = "DefaultDomain", cwd = "~" }),
    },

    {
      key = "n",
      mods = "LEADER",
      action = wezterm.action.ActivateTabRelative(1),
    },
    {
      key = "p",
      mods = "LEADER",
      action = wezterm.action.ActivateTabRelative(-1),
    },

    {
      key = "h",
      mods = "LEADER",
      action = wezterm.action.ActivatePaneDirection("Left"),
    },
    {
      key = "j",
      mods = "LEADER",
      action = wezterm.action.ActivatePaneDirection("Down"),
    },
    {
      key = "k",
      mods = "LEADER",
      action = wezterm.action.ActivatePaneDirection("Up"),
    },
    {
      key = "l",
      mods = "LEADER",
      action = wezterm.action.ActivatePaneDirection("Right"),
    },
  },
}
