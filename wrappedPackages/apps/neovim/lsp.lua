local map = vim.keymap.set

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
  pyright = {},
  ts_ls = {},
  rust_analyzer = {},
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
    python = { "ruff_format" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    go = { "gofmt" },
    rust = { "rustfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
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
  python = { "ruff" },
  go = { "golangci_lint" },
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
