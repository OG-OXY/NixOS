---@diagnostic disable: lowercase-global
---@diagnostic disable: undefined-global


local master_nix_dir = "home/ty/NixOS"

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

  config.action("force-rebase-onto-parent", function()
    local rev = context.change_id()
    if rev then
      jj_interactive("--ignore-immutable", "rebase", "-s", rev, "-o", "@-")
      revisions.refresh()
    end
  end, { desc = "rebase rev onto parent ignoring immutable" })

  config.bind({
    action = "force-rebase-onto-parent",
    seq = { "\\", "r" },
    scope = "revisions",
    desc = "force rebase onto parent",
  })

  config.action("nixos-switch-smart", function()
    local target = "."
    if config.repo and config.repo ~= master_nix_dir then
      -- Only switch target if you explicitly want a non-current repo fallback
      target = "."
    end
    exec_shell("nh os switch " .. target)
    revisions.refresh()
  end, { desc = "nh os switch ." })

  config.bind({
    action = "nixos-switch-smart",
    key = ".",
    scope = "revisions",
    desc = "nh os switch .",
  })
end
