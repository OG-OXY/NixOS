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
end
