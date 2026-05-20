{
  self,
  inputs,
  config,
  ...
}: let
  theme = config.flake.theme.palette;
in {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    themeLua = pkgs.writeText "theme.lua" ''
      local M = {}

      M.colors = {
        base00 = "${theme.base00}",
        base01 = "${theme.base01}",
        base02 = "${theme.base02}",
        base03 = "${theme.base03}",
        base04 = "${theme.base04}",
        base05 = "${theme.base05}",
        base06 = "${theme.base06}",
        base07 = "${theme.base07}",
        base08 = "${theme.base08}",
        base09 = "${theme.base09}",
        base0A = "${theme.base0A}",
        base0B = "${theme.base0B}",
        base0C = "${theme.base0C}",
        base0D = "${theme.base0D}",
        base0E = "${theme.base0E}",
        base0F = "${theme.base0F}",
      }

      function M.setup()
        local c = M.colors

        vim.cmd("highlight clear")
        if vim.fn.exists("syntax_on") == 1 then
          vim.cmd("syntax reset")
        end

        vim.g.colors_name = "flake-theme"
        vim.o.termguicolors = true

        local function hi(group, opts)
          vim.api.nvim_set_hl(0, group, opts)
        end

        hi("Normal", { fg = c.base05, bg = c.base00 })
        hi("NormalNC", { fg = c.base05, bg = c.base00 })
        hi("NormalFloat", { fg = c.base05, bg = c.base01 })
        hi("FloatBorder", { fg = c.base03, bg = c.base01 })
        hi("FloatTitle", { fg = c.base0D, bg = c.base01, bold = true })

        hi("Cursor", { fg = c.base00, bg = c.base07 })
        hi("CursorLine", { bg = c.base01 })
        hi("CursorColumn", { bg = c.base01 })
        hi("ColorColumn", { bg = c.base01 })

        hi("LineNr", { fg = c.base03 })
        hi("CursorLineNr", { fg = c.base0A, bold = true })
        hi("SignColumn", { bg = c.base00 })

        hi("Visual", { bg = c.base02 })
        hi("Search", { fg = c.base00, bg = c.base0A })
        hi("IncSearch", { fg = c.base00, bg = c.base09 })

        hi("Comment", { fg = c.base03, italic = true })
        hi("Constant", { fg = c.base09 })
        hi("String", { fg = c.base0B })
        hi("Character", { fg = c.base0B })
        hi("Number", { fg = c.base09 })
        hi("Boolean", { fg = c.base09 })
        hi("Float", { fg = c.base09 })

        hi("Identifier", { fg = c.base05 })
        hi("Function", { fg = c.base0D })

        hi("Statement", { fg = c.base0E })
        hi("Conditional", { fg = c.base0E })
        hi("Repeat", { fg = c.base0E })
        hi("Label", { fg = c.base0E })
        hi("Operator", { fg = c.base0C })
        hi("Keyword", { fg = c.base0E })
        hi("Exception", { fg = c.base08 })

        hi("PreProc", { fg = c.base0C })
        hi("Include", { fg = c.base0D })
        hi("Define", { fg = c.base0E })
        hi("Macro", { fg = c.base0E })

        hi("Type", { fg = c.base0A })
        hi("StorageClass", { fg = c.base0A })
        hi("Structure", { fg = c.base0A })
        hi("Typedef", { fg = c.base0A })

        hi("Special", { fg = c.base0C })
        hi("SpecialChar", { fg = c.base0C })
        hi("Tag", { fg = c.base0A })
        hi("Delimiter", { fg = c.base04 })
        hi("SpecialComment", { fg = c.base03, italic = true })
        hi("Debug", { fg = c.base08 })

        hi("Error", { fg = c.base08 })
        hi("Todo", { fg = c.base0A, bold = true })

        hi("Pmenu", { fg = c.base05, bg = c.base01 })
        hi("PmenuSel", { fg = c.base07, bg = c.base02 })
        hi("PmenuSbar", { bg = c.base01 })
        hi("PmenuThumb", { bg = c.base03 })

        hi("StatusLine", { fg = c.base06, bg = c.base01 })
        hi("StatusLineNC", { fg = c.base04, bg = c.base01 })
        hi("WinSeparator", { fg = c.base02 })

        hi("TabLine", { fg = c.base04, bg = c.base01 })
        hi("TabLineSel", { fg = c.base07, bg = c.base02, bold = true })
        hi("TabLineFill", { bg = c.base00 })

        hi("Directory", { fg = c.base0D })
        hi("MatchParen", { fg = c.base0A, bg = c.base02, bold = true })

        hi("DiagnosticError", { fg = c.base08 })
        hi("DiagnosticWarn", { fg = c.base0A })
        hi("DiagnosticInfo", { fg = c.base0D })
        hi("DiagnosticHint", { fg = c.base0C })

        hi("DiagnosticVirtualTextError", { fg = c.base08, bg = c.base01 })
        hi("DiagnosticVirtualTextWarn", { fg = c.base0A, bg = c.base01 })
        hi("DiagnosticVirtualTextInfo", { fg = c.base0D, bg = c.base01 })
        hi("DiagnosticVirtualTextHint", { fg = c.base0C, bg = c.base01 })

        hi("GitSignsAdd", { fg = c.base0B })
        hi("GitSignsChange", { fg = c.base0A })
        hi("GitSignsDelete", { fg = c.base08 })

        hi("TelescopeNormal", { fg = c.base05, bg = c.base01 })
        hi("TelescopeBorder", { fg = c.base03, bg = c.base01 })
        hi("TelescopePromptNormal", { fg = c.base05, bg = c.base02 })
        hi("TelescopePromptBorder", { fg = c.base02, bg = c.base02 })
        hi("TelescopePromptTitle", { fg = c.base00, bg = c.base0B, bold = true })
        hi("TelescopePreviewTitle", { fg = c.base00, bg = c.base0D, bold = true })
        hi("TelescopeResultsTitle", { fg = c.base00, bg = c.base0E, bold = true })
        hi("TelescopeSelection", { fg = c.base07, bg = c.base02 })

        hi("NvimTreeNormal", { fg = c.base05, bg = c.base00 })
        hi("NvimTreeFolderName", { fg = c.base0D })
        hi("NvimTreeOpenedFolderName", { fg = c.base0D, bold = true })
        hi("NvimTreeRootFolder", { fg = c.base0E, bold = true })
        hi("NvimTreeGitDirty", { fg = c.base0A })
        hi("NvimTreeGitNew", { fg = c.base0B })
        hi("NvimTreeGitDeleted", { fg = c.base08 })

        hi("WhichKey", { fg = c.base0E })
        hi("WhichKeyGroup", { fg = c.base0D })
        hi("WhichKeyDesc", { fg = c.base05 })
        hi("WhichKeySeparator", { fg = c.base03 })
        hi("WhichKeyFloat", { bg = c.base01 })
      end

      return M
    '';

    initLua = pkgs.writeText "init.lua" ''
      if vim.loader then
        vim.loader.enable()
      end

      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.cursorline = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.wrap = false
      vim.opt.linebreak = true
      vim.opt.scrolloff = 8
      vim.opt.sidescrolloff = 8

      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true

      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = true
      vim.opt.incsearch = true

      vim.opt.splitbelow = true
      vim.opt.splitright = true
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 400

      vim.opt.undofile = true
      vim.opt.swapfile = false
      vim.opt.backup = false

      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      vim.opt.pumheight = 12

      vim.opt.list = true
      vim.opt.listchars = {
        tab = "» ",
        trail = "·",
        nbsp = "␣",
      }

      vim.opt.fillchars = {
        eob = " ",
        fold = " ",
        foldopen = "",
        foldsep = " ",
        foldclose = "",
      }

      local theme = dofile("${themeLua}")
      theme.setup()

      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      local map = vim.keymap.set

      map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
      map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
      map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

      map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

      map("n", "<c-h>", "<c-w>h", { desc = "Move left" })
      map("n", "<c-j>", "<c-w>j", { desc = "Move down" })
      map("n", "<c-k>", "<c-w>k", { desc = "Move up" })
      map("n", "<c-l>", "<c-w>l", { desc = "Move right" })

      map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
      map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })

      map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
      map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
      map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

      map("v", "<", "<gv", { desc = "Indent left" })
      map("v", ">", ">gv", { desc = "Indent right" })

      require("nvim-autopairs").setup({})
      require("Comment").setup({})
      require("which-key").setup({})

      local ok_ibl, ibl = pcall(require, "ibl")

      if ok_ibl then
        ibl.setup({
          indent = {
            char = "│",
          },
          scope = {
            enabled = true,
            show_start = false,
            show_end = false,
          },
        })
      else
        require("indent_blankline").setup({
          char = "│",
          show_current_context = true,
          show_current_context_start = false,
        })
      end

      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
      })

      local fzf = require("fzf-lua")

      fzf.setup({
        winopts = {
          height = 0.85,
          width = 0.9,
          row = 0.5,
          col = 0.5,
          border = "rounded",
          preview = {
            layout = "horizontal",
            horizontal = "right:55%",
          },
        },
        files = {
          prompt = "Files❯ ",
          fd_opts = "--color=never --type f --hidden --follow --exclude .git",
        },
        grep = {
          prompt = "Grep❯ ",
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'",
        },
        keymap = {
          builtin = {
            ["<Esc>"] = "hide",
          },
          fzf = {
            ["ctrl-q"] = "select-all+accept",
          },
        },
      })

      map("n", "<leader>ff", fzf.files, { desc = "Find files" })
      map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
      map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
      map("n", "<leader>fh", fzf.helptags, { desc = "Help tags" })
      map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
      map("n", "<leader>fc", fzf.commands, { desc = "Commands" })
      map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })

      require("nvim-treesitter").setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })

      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      require("blink.cmp").setup({
        keymap = {
          preset = "super-tab",
        },

        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "mono",
        },

        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
          menu = {
            border = "rounded",
          },
        },

        signature = {
          enabled = true,
          window = {
            border = "rounded",
          },
        },

        snippets = {
          preset = "luasnip",
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local on_attach = function(_, bufnr)
        local opts = function(desc)
          return { buffer = bufnr, desc = desc }
        end

        map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
        map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
        map("n", "gr", vim.lsp.buf.references, opts("References"))
        map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
        map("n", "K", vim.lsp.buf.hover, opts("Hover"))
        map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
        map("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
        map("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
        map("n", "<leader>ld", vim.diagnostic.open_float, opts("Line diagnostic"))
      end

      local servers = {
        nixd = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        jsonls = {},
        yamlls = {},
        taplo = {},
        marksman = {},
        bashls = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach

        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      require("conform").setup({
        formatters_by_ft = {
          nix = { "alejandra" },
          lua = { "stylua" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
          json = { "jq" },
          toml = { "taplo" },
          markdown = { "marksman" },
        },

        format_on_save = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
      })

      map("n", "<leader>lf", function()
        require("conform").format({
          async = true,
          lsp_format = "fallback",
        })
      end, { desc = "Format" })

      local lint = require("lint")

      lint.linters_by_ft = {
        nix = { "statix", "deadnix" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })

      map("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Lint current file" })

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = {
            normal = {
              a = { fg = "${theme.base00}", bg = "${theme.base0D}", gui = "bold" },
              b = { fg = "${theme.base06}", bg = "${theme.base02}" },
              c = { fg = "${theme.base05}", bg = "${theme.base01}" },
            },
            insert = {
              a = { fg = "${theme.base00}", bg = "${theme.base0B}", gui = "bold" },
            },
            visual = {
              a = { fg = "${theme.base00}", bg = "${theme.base0E}", gui = "bold" },
            },
            replace = {
              a = { fg = "${theme.base00}", bg = "${theme.base08}", gui = "bold" },
            },
            command = {
              a = { fg = "${theme.base00}", bg = "${theme.base0A}", gui = "bold" },
            },
            inactive = {
              a = { fg = "${theme.base04}", bg = "${theme.base01}" },
              b = { fg = "${theme.base04}", bg = "${theme.base01}" },
              c = { fg = "${theme.base04}", bg = "${theme.base00}" },
            },
          },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
      })

      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
          offsets = {
            {
              filetype = "NvimTree",
              text = "Files",
              highlight = "Directory",
              separator = true,
            },
          },
        },
        highlights = {
          fill = { bg = "${theme.base00}" },
          background = { fg = "${theme.base04}", bg = "${theme.base01}" },
          buffer_selected = { fg = "${theme.base07}", bg = "${theme.base02}", bold = true },
          separator = { fg = "${theme.base00}", bg = "${theme.base01}" },
          separator_selected = { fg = "${theme.base00}", bg = "${theme.base02}" },
        },
      })
    '';

    nvimPackage = pkgs.neovim.override {
      configure = {
        customRC = ''
          lua << EOF
          local ok, err = pcall(dofile, "${initLua}")

          if not ok then
            vim.api.nvim_err_writeln(err)
          end
          EOF
        '';

        packages.all.start = with pkgs.vimPlugins; [
          nvim-web-devicons

          fzf-lua

          nvim-tree-lua

          nvim-treesitter.withAllGrammars

          nvim-lspconfig

          blink-cmp
          luasnip
          friendly-snippets

          conform-nvim
          nvim-lint

          lualine-nvim
          bufferline-nvim
          gitsigns-nvim

          nvim-autopairs
          comment-nvim
          indent-blankline-nvim
          which-key-nvim
        ];
      };
    };
  in {
    packages.neovim = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = nvimPackage;

      runtimeInputs = with pkgs; [
        # search/file tools
        ripgrep
        fd
        fzf
        git

        # formatters / linters
        alejandra
        statix
        deadnix
        stylua
        shfmt
        shellcheck
        jq
        taplo

        # language servers
        nil
        nixd
        lua-language-server
        bash-language-server
        vscode-langservers-extracted
        yaml-language-server
        taplo
        marksman
      ];

      env = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}