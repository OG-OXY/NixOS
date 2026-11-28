----@diagnostic disable: lowercase-global

---@param config any
function setup(config)
  config.action("open-helix", function()
    exec_shell("hx")
  end, { desc = "open Helix" })

  config.bind({
    action = "open-helix",
    key = "H",
    scope = "revisions",
    desc = "open Helix",
  })

  config.action("force-describe", function()
    local rev = context.change_id()
    if rev then
      jj_interactive("--ignore-immutable", "describe", "-r", rev)
      revisions.refresh()
    end
  end, { desc = "describe ignoring immutable" })

  config.bind({
    action = "force-describe",
    key = "D",
    scope = "revisions",
    desc = "describe ignoring immutable",
  })

  config.action("force-rebase", function()
    jj_interactive("--ignore-immutable", "rebase")
    revisions.refresh()
  end, { desc = "rebase ignoring immutable" })

  config.bind({
    action = "force-rebase",
    key = "R",
    scope = "revisions",
    desc = "rebase ignoring immutable",
  })
end
