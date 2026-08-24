{
  description = "NVF Neovim IDE Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iTerm2.url = "github:mbadolato/iTerm2-Color-Schemes/ghostty/Aurora";
  };

  outputs =
    {
      nixpkgs,
      nvf,
      iTerm2,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          Aurora = builtins.readFile "${iTerm2}";
          customNeovim = nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              {
                config.vim = {
                  viAlias = false;
                  vimAlias = false;

                  treesitter = {
                    enable = true;
                    fold = true;
                    highlight.enable = true;
                    grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars ++ [
                      pkgs.tree-sitter-grammars.tree-sitter-norg
                      pkgs.tree-sitter-grammars.tree-sitter-norg-meta
                    ];
                  };

                  options = {
                    shiftwidth = 2;
                    tabstop = 2;
                    expandtab = true;
                    termguicolors = true;
                    number = true;
                    relativenumber = true;
                    foldlevel = 99;
                    foldlevelstart = 99;
                    clipboard = "unnamedplus";
                    undofile = true;
                    mouse = "a";
                  };

                  theme = {
                    enable = false;
                    name = "gruvbox";
                    style = "dark";
                    transparent = false;
                  };

                  statusline.lualine.enable = true;

                  visuals = {
                    nvim-web-devicons.enable = true;
                    nvim-scrollbar.enable = true;
                    cinnamon-nvim.enable = true;
                    indent-blankline.enable = true;
                    nvim-cursorline.enable = true;
                  };

                  dashboard.alpha.enable = true;
                  filetree.neo-tree.enable = true;
                  telescope.enable = true;

                  git = {
                    enable = true;
                    gitsigns.enable = true;
                  };

                  autopairs.nvim-autopairs.enable = true;
                  utility.motion.hop.enable = true;
                  binds.whichKey.enable = true;

                  terminal.toggleterm = {
                    enable = true;
                    setupOpts.direction = "float";
                  };

                  tabline.nvimBufferline.enable = true;
                  autocomplete.blink-cmp.enable = true;
                  snippets.luasnip.enable = true;

                  # Keymaps
                  keymaps = [
                    {
                      key = "<leader>e";
                      action = ":Neotree toggle<CR>";
                      mode = "n";
                      desc = "Toggle Explorer";
                    }
                    {
                      key = "<leader>ff";
                      action = ":Telescope find_files<CR>";
                      mode = "n";
                      desc = "Find Files";
                    }
                    {
                      key = "<leader>fw";
                      action = ":Telescope live_grep<CR>";
                      mode = "n";
                      desc = "Find Words";
                    }
                    {
                      key = "<leader>tf";
                      action = ":ToggleTerm<CR>";
                      mode = "n";
                      desc = "Toggle Floating Terminal";
                    }
                    {
                      key = "L";
                      action = ":BufferLineCycleNext<CR>";
                      mode = "n";
                      desc = "Next Buffer";
                    }
                    {
                      key = "H";
                      action = ":BufferLineCyclePrev<CR>";
                      mode = "n";
                      desc = "Previous Buffer";
                    }
                    {
                      key = "<leader>c";
                      action = ":bdelete<CR>";
                      mode = "n";
                      desc = "Close Buffer";
                    }
                    {
                      key = "<leader>y";
                      action = "\"+y";
                      mode = [
                        "n"
                        "v"
                      ];
                      desc = "Yank to Clipboard";
                    }
                    {
                      key = "<leader>p";
                      action = "\"+p";
                      mode = [
                        "n"
                        "v"
                      ];
                      desc = "Paste from Clipboard";
                    }
                    {
                      key = "<leader>qf";
                      action = "lua vim.lsp.buf.format()";
                      mode = [ "n" ];
                      desc = "Format Buffer Manually";
                    }
                    {
                      key = "<leader>w";
                      action = ''
                        lua function()
                          if vim.bo.filetype ~= "nix" then
                            vim.lsp.buf.format({ async = false })
                          end
                          vim.cmd('write')
                        end()
                      '';
                      mode = [ "n" ];
                      desc = "Save (format if not Nix)";
                    }
                  ];

                  lsp = {
                    enable = true;
                    formatOnSave = false;
                    servers.lua-language-server = {
                      settings = {
                        Lua = {
                          workspace = {
                            checkThirdParty = false;
                            library = [
                              "${pkgs.hyprland}/share/hypr/stubs"
                            ];
                          };
                          diagnostics = {
                            globals = [ "hl" ];
                          };
                        };
                      };
                    };
                  };

                  # Language Modules
                  languages = {
                    enableTreesitter = true;
                    enableFormat = true;
                    enableExtraDiagnostics = true;

                    rust.enable = true;
                    clang.enable = true;

                    nix = {
                      enable = true;
                      lsp.servers = [ "nixd" ];
                      format.type = [ "nixfmt" ];
                    };

                    lua = {
                      enable = true;
                      lsp.servers = [ "lua-language-server" ];
                      format.type = [ "stylua" ];
                    };

                    python = {
                      enable = true;
                      lsp.servers = [
                        "pyright"
                        "basedpyright"
                        "python-lsp-server"
                      ];
                      format.type = [ "black" ];
                    };

                    markdown = {
                      enable = true;
                      lsp.enable = true;
                      format.type = [ "deno" ];
                    };

                    yaml = {
                      enable = true;
                      format.type = [ "prettier" ];
                    };

                    fish.enable = true;
                    bash.enable = true;
                    json.enable = true;
                    toml.enable = true;
                    css.enable = true;
                    xml.enable = true;
                    html.enable = true;
                  };

                  diagnostics.presets = {
                    statix.enable = true;
                    deadnix.enable = true;
                  };

                  luaConfigRC = {
                    master-repo-grep = ''
                      vim.api.nvim_create_user_command('Masterg', function()
                        require('telescope.builtin').live_grep({
                          cwd = "/home/ty/NixOS/Master/",
                          prompt_title = "Master Repo Grep",
                        })
                      end, {})
                    '';
                    smart-write-commands = ''
                      local function smart_write(extra_cmd)
                        if vim.bo.filetype ~= "nix" then
                          pcall(vim.lsp.buf.format, { async = false })
                        end
                        vim.cmd('write')
                        if extra_cmd then
                          vim.cmd(extra_cmd)
                        end
                      end

                      vim.api.nvim_create_user_command('W', function() smart_write() end, {})
                      vim.api.nvim_create_user_command('Wq', function() smart_write('quit') end, {})
                      vim.api.nvim_create_user_command('WQ', function() smart_write('quit') end, {})
                    '';
                    buffer-quit-autosave = ''
                      vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
                        pattern = "*",
                        command = "silent! wa",
                      })
                    '';
                    aurora-custom-theme = ''
                      local aurora-theme = [[
                      ${Aurora}
                      ]]
                    '';
                    neorg-auto-export = ''
                      vim.api.nvim_create_autocmd("BufWritePost", {
                        pattern = "*.norg",
                        callback = function()
                          vim.cmd("Neorg export to-file " .. vim.fn.expand("%:r") .. ".md")
                        end,
                      })
                    '';
                    treesitter-auto-start = ''
                      vim.api.nvim_create_autocmd("FileType", {
                        pattern = "*",
                        callback = function()
                          pcall(vim.treesitter.start)
                        end,
                      })
                    '';
                  };

                  notes = {
                    neorg = {
                      enable = true;
                      setupOpts = {
                        load = {
                          "core.defaults" = { };
                          "core.concealer" = { };
                          "core.dirman" = {
                            config = {
                              workspaces = {
                                notes = "~/Documents/Notes";
                                sync = "~/.norg_sync";
                              };
                              default_workspace = "Notes";
                            };
                            "core.completion" = {
                              config = {
                                engine = "blink";
                              };
                            };
                            "core.export" = { };
                            "core.export.markdown" = { };
                          };
                        };
                      };
                    };
                  };
                };
              }
            ];
          };
        in
        {
          default = pkgs.symlinkJoin {
            name = "nvf-wrapped";
            paths = [ customNeovim.neovim ];
            postBuild = ''
              ln -s $out/bin/nvim $out/bin/nvf
            '';
          };
        }
      );
    };
}
