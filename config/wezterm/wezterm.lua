local wezterm = require("wezterm")
local scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local home_dir = wezterm.home_dir
  if pane.domain_name == "dkfz-workstation" then
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

return {
  -- basics
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font("VictorMono Nerd Font"),
  font_size = 17,

  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  tab_max_width = 32,

  term = "wezterm",

  -- remotes
  unix_domains = {
    {
      name = "dkfz-workstation",
      local_echo_threshold_ms = 150,
      proxy_command = { "ssh", "-T", "-A", "dkfz-workstation", "wezterm", "cli", "proxy" },
    },
  },

  ssh_domains = {
    {
      -- This name identifies the domain
      name = "dkfz-worker01",
      remote_address = "dkfz-worker",
      username = "t974t",
      assume_shell = "Posix",
      local_echo_threshold_ms = 150,
    },

    {
      name = "dkfz-worker02",
      remote_address = "dkfz-worker2",
      username = "t974t",
      local_echo_threshold_ms = 150,
      remote_wezterm_path = "/dkfz/cluster/gpu/data/OE0612/t974t/.local/bin/wezterm",
    },
  },

  -- keys
  leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
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
  },
}
