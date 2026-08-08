local theme = require("theme")
local c = theme.colors
local map = vim.keymap.set

require("nvim-autopairs").setup({})
require("Comment").setup({})
require("which-key").setup({})

require("indent_blankline").setup({
  char = "│",
  show_current_context = true,
  show_current_context_start = false,
})

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

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = {
      normal = {
        a = { fg = c.base00, bg = c.base0D, gui = "bold" },
        b = { fg = c.base06, bg = c.base02 },
        c = { fg = c.base05, bg = c.base01 },
      },
      insert = {
        a = { fg = c.base00, bg = c.base0B, gui = "bold" },
      },
      visual = {
        a = { fg = c.base00, bg = c.base0E, gui = "bold" },
      },
      replace = {
        a = { fg = c.base00, bg = c.base08, gui = "bold" },
      },
      command = {
        a = { fg = c.base00, bg = c.base0A, gui = "bold" },
      },
      inactive = {
        a = { fg = c.base04, bg = c.base01 },
        b = { fg = c.base04, bg = c.base01 },
        c = { fg = c.base04, bg = c.base00 },
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
    fill = { bg = c.base00 },
    background = { fg = c.base04, bg = c.base01 },
    buffer_selected = { fg = c.base07, bg = c.base02, bold = true },
    separator = { fg = c.base00, bg = c.base01 },
    separator_selected = { fg = c.base00, bg = c.base02 },
  },
})

require("neotest").setup({
  adapters = {
    require("neotest-plenary"),
    require("neotest-python")({ pytest = { python = "python3" } }),
    require("neotest-go"),
    require("neotest-rust")({ args = { "--no-capture" } }),
  },
})

map("n", "<leader>tr", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })
map("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })
map("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })
map("n", "<leader>to", function()
  require("neotest").output.open({ enter = true })
end, { desc = "Open test output" })

local dap = require("dap")

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "@codelldb@",
    args = { "--port", "${port}" },
  },
}

for _, lang in ipairs({ "c", "cpp", "rust", "zig" }) do
  dap.configurations[lang] = {
    {
      type = "codelldb",
      request = "launch",
      name = "Debug (codelldb)",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
end

dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}

dap.configurations.go = {
  {
    type = "delve",
    request = "launch",
    name = "Debug (delve)",
    program = "${workspaceFolder}",
  },
}

dap.adapters.python = {
  type = "executable",
  command = "@debugpyPython@",
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Debug (debugpy)",
    program = "${file}",
  },
}

require("dapui").setup({})

map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Continue" })
map("n", "<leader>do", function()
  require("dapui").toggle()
end, { desc = "Toggle DAP UI" })

require("render-markdown").setup({})
map("n", "<leader>md", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown render" })
