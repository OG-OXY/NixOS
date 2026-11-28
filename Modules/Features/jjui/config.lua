---@diagnostic disable: lowercase-global, undefined-global

local master_nix_dir = "/home/ty/NixOS"

---@param config any
function setup(config)
  -- External tools (inline key + scope skips separate config.bind calls)
  config.action("open-helix", function()
    exec_shell("hx")
  end, { key = "H", scope = "revisions", desc = "open Helix" })

  config.action("nixos-switch", function()
    local target = (config.repo and config.repo ~= master_nix_dir) and master_nix_dir or "."
    exec_shell("nh os switch " .. target)
    revisions.refresh()
  end, { key = ".", scope = "revisions", desc = "nh os switch" })

  -- Always allow empty descriptions on push
  config.action("git.push", function()
    jj_async("git", "push", "--allow-empty-description")
    revisions.refresh()
  end)

  -- Shim built-in apply/accept actions to ignore immutability
  local force_overrides = {
    ["revisions.inline_describe.accept"] = jjui.builtin.revisions.inline_describe.force_accept,
    ["revisions.rebase.apply"] = jjui.builtin.revisions.rebase.force_apply,
    ["revisions.abandon.apply"] = jjui.builtin.revisions.abandon.force_apply,
    ["revisions.squash.apply"] = jjui.builtin.revisions.squash.force_apply,
    ["revisions.duplicate.apply"] = jjui.builtin.revisions.duplicate.force_apply,
    ["revisions.revert.apply"] = jjui.builtin.revisions.revert.force_apply,
    ["revisions.target_picker.apply"] = jjui.builtin.revisions.target_picker.force_apply,
  }

  for name, force_fn in pairs(force_overrides) do
    config.action(name, force_fn)
  end
end
