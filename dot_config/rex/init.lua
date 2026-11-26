-- Rex configuration migrated from Ghostty and iTerm2.

-- iTerm2 GlobalKeyMap "0xd-0x20000": shift+enter sends a newline.
rex.bind("shift+enter", "pane.send_key", { key = "enter" })

-- cmd+j reuses one "opencode" session and adds a tab to it on each press,
-- showing the tab it just created.
rex.action{
  name     = "opencode",
  title    = "New OpenCode Tab",
  category = "Session",
  keywords = "opencode agent ai tab",
  run      = function(ctx, args)
    local layout = rex.layout.block{
      flavor  = "com.superlogical.terminal.shell",
      options = { command = { "opencode" } },
    }

    local target
    local list, list_err = rex.call("session.list")
    if list_err ~= nil then error(list_err, 0) end
    for _, session in ipairs(list.sessions or {}) do
      if session.label == "opencode" then
        target = session.session_id
        break
      end
    end

    local window_id
    if target == nil then
      local created, err = rex.call("session.create", {
        label           = "opencode",
        initial_windows = { { window_label = "opencode 1", layout = layout } },
      })
      if err ~= nil then error(err, 0) end
      target    = created.session_id
      window_id = created.initial_windows[1].window_id
      local _, attach_err = rex.call("session.attach", { session_id = target })
      if attach_err ~= nil then error(attach_err, 0) end
    else
      -- a window in another session only accepts this after the stream
      -- attaches to that session
      local _, attach_err = rex.call("session.attach", { session_id = target })
      if attach_err ~= nil then error(attach_err, 0) end
      local view = rex.call("session.view", { session_id = target })
      local highest = 0
      for _, window in ipairs((view and view.windows) or {}) do
        local n = tonumber((tostring(window.label or ""):match("opencode (%d+)")))
        if n ~= nil and n > highest then highest = n end
      end
      local new_window, err = rex.call("session.new_window", {
        session_id   = target,
        window_label = "opencode " .. tostring(highest + 1),
        layout       = layout,
      })
      if err ~= nil then error(err, 0) end
      if new_window ~= nil then window_id = new_window.window_id end
    end

    if ctx.client_id ~= nil and (ctx.origin == "key" or ctx.origin == "palette") then
      -- the app only learns about the new window after this action returns,
      -- so a select by id sent now can be ignored; open the session first and
      -- let opencode_focus pick the window once the app has caught up. It runs
      -- twice because switching sessions can still be in progress the first
      -- time, which drops the selection.
      if ctx.session_id ~= target then
        local select = { session_id = target }
        if window_id ~= nil then select.window_id = window_id end
        rex.client.queue("session.select", select)
      end
      rex.client.queue("opencode_focus")
      rex.client.queue("opencode_focus")
    end
  end,
}

rex.action{
  name     = "opencode_focus",
  title    = "Show Newest OpenCode Tab",
  category = "Session",
  keywords = "opencode agent ai tab focus",
  run      = function(ctx, args)
    local list, list_err = rex.call("session.list")
    if list_err ~= nil then error(list_err, 0) end
    local target
    for _, session in ipairs(list.sessions or {}) do
      if session.label == "opencode" then
        target = session.session_id
        break
      end
    end
    if target == nil or ctx.client_id == nil then return end

    local _, attach_err = rex.call("session.attach", { session_id = target })
    if attach_err ~= nil then error(attach_err, 0) end
    local view = rex.call("session.view", { session_id = target })
    local windows = (view and view.windows) or {}
    local newest = windows[#windows]
    if newest == nil then return end

    rex.client.queue("session.select", { session_id = target, window_id = newest.window_id })
    rex.client.queue("client.tab.goto", { index = -1 })
  end,
}
rex.bind("cmd+j", "opencode")

-- cmd+d is the Rex version of cmux's "New Day" workspace: a session in
-- ~/projetos/OCM-new with one tab per daily report, the first one focused.
local new_day_dir = "/Users/rafael/projetos/OCM-new"
local new_day_jobs = {
  {
    title   = "Oq Fiz hoje",
    command = { "opencode", "mini", "--prompt", "/oq-fiz-ontem" },
  },
  {
    title   = "Sprint Status",
    command = {
      "opencode",
      "--prompt",
      "Leia e siga /Users/rafael/.claude/plugins/marketplaces/hyperfleet-claude-plugins/hyperfleet-jira/commands/sprint-status.md para gerar o status da sprint HYPERFLEET.",
    },
  },
  {
    title   = "Renovate PRs",
    command = {
      "opencode",
      "--prompt",
      "Leia e siga a skill em /Users/rafael/.claude/plugins/marketplaces/hyperfleet-claude-plugins/hyperfleet-devtools/skills/renovate-prs/SKILL.md. Para coletar os dados, execute bash /Users/rafael/.claude/plugins/marketplaces/hyperfleet-claude-plugins/hyperfleet-devtools/skills/renovate-prs/scripts/collect-data.sh.",
    },
  },
  {
    title   = "Verifica Tickets",
    command = {
      "opencode",
      "--prompt",
      "Siga a skill @verifica-tickets para verificar tickets recentes. Use o período padrão da skill.",
    },
  },
}

rex.action{
  name     = "new_day",
  title    = "New Day Workspace",
  category = "Session",
  keywords = "new day daily opencode reports",
  run      = function(ctx, args)
    local windows = {}
    for _, job in ipairs(new_day_jobs) do
      windows[#windows + 1] = {
        window_label = job.title,
        layout       = rex.layout.block{
          flavor  = "com.superlogical.terminal.shell",
          options = { command = job.command, cwd = new_day_dir },
        },
      }
    end
    local created, err = rex.call("session.create", {
      label           = "New Day",
      initial_windows = windows,
    })
    if err ~= nil then error(err, 0) end
    rex.call("session.attach", { session_id = created.session_id })
    rex.call("session.focus_window", {
      session_id = created.session_id,
      window_id  = created.initial_windows[1].window_id,
    })
    if ctx.client_id ~= nil and (ctx.origin == "key" or ctx.origin == "palette") then
      rex.client.queue("session.select", { session_id = created.session_id })
    end
  end,
}
rex.bind("cmd+d", "new_day")
