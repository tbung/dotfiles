local wezterm = require("wezterm")
local act = wezterm.action

local catppuccin_black = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
catppuccin_black.background = "#000000"                          -- "#1e1e2e"
catppuccin_black.cursor_fg = "#000000"                           -- "#11111b"
catppuccin_black.tab_bar.active_tab.fg_color = "#000000"         -- "#11111b"
catppuccin_black.tab_bar.background = "#000000"                  -- "#11111b"
catppuccin_black.tab_bar.inactive_tab.bg_color = "#000000"       -- "#181825"
catppuccin_black.tab_bar.inactive_tab_hover.bg_color = "#000000" -- "#1e1e2e"

local scheme_name = "Catppuccin Mocha"

local scheme_file = io.input(wezterm.config_dir .. "/colorscheme")
if scheme_file ~= nil then
  local maybe_scheme_name = scheme_file:read()
  scheme_file:close()
  if wezterm.color.get_builtin_schemes()[maybe_scheme_name] ~= nil or maybe_scheme_name == "Catppuccin Black" then
    scheme_name = maybe_scheme_name
  end
end

local scheme
if scheme_name == "Catppuccin Black" then
  scheme = catppuccin_black
else
  scheme = wezterm.color.get_builtin_schemes()[scheme_name]
end
local bsp = require("bsp")

local default_font_size = 16

local screen = nil

local function get_font_size(window)
  if not window then
    return default_font_size
  end

  if screen == nil and window:is_focused() then
    screen = wezterm.gui.screens().active
  end

  local num_lines
  if screen.name == "Built-in Retina Display" then
    num_lines = 46
  else
    num_lines = 56
  end

  local dimensions = window:get_dimensions()
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

wezterm.on("user-var-changed", function(window, pane, name, value)
  -- TODO: Just use hammerspoon/notify for notification depending on OS
  if name == "to_wezterm_command_done" then
    wezterm.log_info("the bell was rung in pane " .. pane:pane_id() .. "!")
    local success, stdout, stderr = wezterm.run_child_process({
      "/usr/local/bin/hs",
      "-c",
      'hs.notify.show("test1", "test1", "test1"):delivered()',
    })
    wezterm.log_info("success=" .. (success and "true" or "false"))
    wezterm.log_info("stdout=" .. stdout)
    wezterm.log_info("stderr=" .. stderr)
  end
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = pane.title

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
    key = "o",
    mods = "LEADER",
    action = wezterm.action.TogglePaneZoomState,
  },

  {
    key = "0",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      screen = nil -- force font size update
      overrides.font_size = get_font_size(window)
      print(overrides.font_size)
      window:set_config_overrides(overrides)
      window:perform_action(wezterm.action.ResetFontSize, pane)
    end),
  },

  {
    key = "[",
    mods = "LEADER",
    action = wezterm.action.ActivateCopyMode,
  },

  {
    key = "=",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      local tab = window:active_tab()

      ---@type Node[]
      local nodes = {}

      for _, p in ipairs(tab:panes_with_info()) do
        table.insert(
          nodes,
          bsp.Node.new({
            left = p.left,
            top = p.top,
            width = p.width,
            height = p.height,
            pane = p.pane:pane_id(),
            children = { nil, nil },
          })
        )
      end

      local tree = bsp.build_tree(nodes)

      local old_pane = window:active_pane()

      tree:balance(nil, function(node)
        local direction
        local amount

        local node_pane = wezterm.mux.get_pane(node.pane)
        print("pane=" .. node.pane)


        if node.width ~= node_pane:get_dimensions().cols then
          direction = (node.width > node_pane:get_dimensions().cols) and "Right" or "Left"
          amount = math.abs(node.width - node_pane:get_dimensions().cols)
          print("direction=" .. direction .. " amount=" .. amount)
          node_pane:activate()
          window:perform_action(wezterm.action.AdjustPaneSize({ direction, amount }), node_pane)
        end

        if node.height ~= node_pane:get_dimensions().viewport_rows then
          direction = (node.height > node_pane:get_dimensions().viewport_rows) and "Down" or "Up"
          amount = math.abs(node.height - node_pane:get_dimensions().viewport_rows)
          print("direction=" .. direction .. " amount=" .. amount)
          node_pane:activate()
          window:perform_action(wezterm.action.AdjustPaneSize({ direction, amount }), node_pane)
        end
      end)

      old_pane:activate()
    end),
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
  color_schemes = {
    ["Catppuccin Black"] = catppuccin_black,
  },
  color_scheme = scheme_name,
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
