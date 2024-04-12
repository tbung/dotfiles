local wezterm = require("wezterm")
local act = wezterm.action
local scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

local default_font_size = 16

local screen = nil

local function get_font_size(window)
  if not window then
    return default_font_size
  end

  local num_lines = 56

  local dimensions = window:get_dimensions()
  if screen == nil and window:is_focused() then
    screen = wezterm.gui.screens().active
  end
  return screen.height / num_lines * 48 / dimensions.dpi
end

local function basename(s)
  if s == nil or s == "" then
    return nil
  end
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function escape(pattern)
  if pattern == nil or pattern == "" then
    return nil
  end
  return pattern:gsub("%W", "%%%1")
end

local function ssh_domains()
  local _ssh_domains = wezterm.default_ssh_domains()
  for i, dom in ipairs(_ssh_domains) do
    if dom.name == "SSH:dkfz-worker" then
      dom.default_prog = { "/dkfz/cluster/gpu/data/OE0612/t974t/.local/bin/zsh", "-l" }
    end
    if dom.name == "SSHMUX:dkfz-worker" then
      table.remove(_ssh_domains, i)
    end
  end
  return _ssh_domains
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local home_dir = wezterm.home_dir

  if pane.domain_name:find("dkfz-work", 1, true) ~= nil then
    home_dir = "/home/t974t"
  end

  local proc, _, domain
  local domain_name = pane.domain_name
  if domain_name == "SSH:dkfz-worker" then
    domain_name = "SSH:cluster"
  end
  if domain_name == "SSHMUX:dkfz-workstation" then
    domain_name = "SSHMUX:dkfz"
  end

  if pane.domain_name:find("SSH:", 1, true) == 1 then
    proc = basename(pane.user_vars.WEZTERM_PROG) or basename(pane.user_vars.WEZTERM_SHELL) or pane.title
    -- domain = "(" .. domain_name .. ") "
    domain = ""
  elseif pane.foreground_process_name ~= "" then
    proc = basename(pane.foreground_process_name) or pane.title
    domain = ""
  else
    proc = pane.title
    if domain_name:find("MUX", 1, true) ~= nil then
      -- domain = "(" .. string.gsub(domain_name, "SSHMUX:", "") .. ") "
      domain = ""
    else
      domain = ""
    end
  end

  local title
  if pane.current_working_dir ~= nil then
    title = pane.current_working_dir.path
    title = string.gsub(title, home_dir, "~")
    title = string.gsub(title, "~/Projects", "~p")
    title = string.gsub(title, "/$", "")

    title = domain .. proc .. " - " .. title
  else
    title = pane.title
  end
  title = (tab.tab_index + 1) .. ": " .. title
  title = wezterm.truncate_right(title, max_width - 4)
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
    { Text = window:active_workspace() .. " @ " .. pane:get_domain_name() },
  }))
end)

wezterm.on("update-status", function(window, pane)
  local meta = pane:get_metadata() or {}
  if meta.is_tardy then
    local secs = meta.since_last_response_ms / 1000.0
    window:set_right_status(string.format("tardy: %5.1fs⏳", secs))
  end

  -- update font size to match screen size
  if not window:is_focused() then
    return
  end
  local overrides = window:get_config_overrides() or {}

  local font_size = get_font_size(window)

  if overrides.font_size and overrides.font_size == font_size then
    return
  end

  overrides.font_size = font_size
  overrides.command_palette_font_size = font_size
  window:set_config_overrides(overrides)
end)

wezterm.on("window-resized", function(window, pane)
  if window:is_focused() then
    screen = wezterm.gui.screens().active
  end
end)

local keys = {
  {
    key = "a",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      local success, stdout, stderr = wezterm.run_child_process({
        "ssh",
        "dkfz-workstation",
        "zsh",
        "-lc",
        [["fd -t d -d 1 . /home/t974t/Projects"]],
      })

      if not success then
        return
      end

      -- wezterm.log_info(tostring(success))
      -- wezterm.log_info(wezterm.split_by_newlines(stdout))

      local choices = {}
      for _, value in ipairs(wezterm.split_by_newlines(stdout)) do
        table.insert(choices, { label = value:gsub([[.*/]], ""), id = value })
      end

      window:perform_action(
        act.InputSelector({
          action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
            if not id and not label then
              wezterm.log_info("cancelled")
            else
              wezterm.log_info("id = " .. id)
              wezterm.log_info("label = " .. label)
              inner_window:perform_action(
                act.SwitchToWorkspace({
                  name = label,
                  spawn = {
                    label = "Workspace: " .. label,
                    cwd = id,
                    domain = { DomainName = "SSHMUX:dkfz-workstation" },
                  },
                }),
                inner_pane
              )
            end
          end),
          title = "Choose Workspace",
          choices = choices,
          fuzzy = true,
          fuzzy_description = "Fuzzy find and/or make a workspace > ",
        }),
        pane
      )
    end),
  },

  {
    key = " ",
    mods = "LEADER|CTRL",
    action = wezterm.action.SendKey({ key = " ", mods = "CTRL" }),
  },
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
    action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }),
  },
  {
    key = "w",
    mods = "LEADER",
    action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
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
    key = "N",
    mods = "LEADER",
    action = wezterm.action.MoveTabRelative(1),
  },
  {
    key = "P",
    mods = "LEADER",
    action = wezterm.action.MoveTabRelative(-1),
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

  {
    key = "[",
    mods = "LEADER",
    action = wezterm.action.ActivateCopyMode,
  },
}

for i = 1, 9 do
  table.insert(keys, {
    key = tostring(i),
    mods = "LEADER",
    action = wezterm.action.ActivateTab(i - 1),
  })
end

return {
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font_with_fallback({ "VictorMono Nerd Font", "VictorMono NF" }),
  font_size = get_font_size(),
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  tab_max_width = 48,
  term = "wezterm",
  native_macos_fullscreen_mode = true,
  front_end = "WebGpu",

  command_palette_bg_color = "#11111b",
  command_palette_fg_color = "#cdd6f4",
  command_palette_font_size = get_font_size(),

  ssh_domains = ssh_domains(),
  send_composed_key_when_left_alt_is_pressed = true,

  -- TODO: Add custom lua function keys, for example for launcher stuff and balancing split panes
  -- via `action = wezterm.action_callback(function(window, pane) ... end)`
  leader = { key = " ", mods = "CTRL", timeout_milliseconds = 3000 },
  keys = keys,
}
