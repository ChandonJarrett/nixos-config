{ ... }: {
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      nixd.enable = true;       # Nix LSP 
      lua_ls.enable = true;     # Lua (for Neovim config itself)
      ts_ls.enable = true;    # TypeScript / JavaScript
      pyright.enable = true;  # Python
      gopls.enable = true;    # Go
    };

    keymaps = {
      diagnostic = {
        "[d" = { action = "goto_prev";   desc = "Prev diagnostic"; };
        "]d" = { action = "goto_next";   desc = "Next diagnostic"; };
        "<leader>cd" = { action = "open_float"; desc = "Line diagnostics"; };
      };
      lspBuf = {
        "gd"         = { action = "definition";     desc = "Go to definition"; };
        "gD"         = { action = "declaration";    desc = "Go to declaration"; };
        "gr"         = { action = "references";     desc = "References"; };
        "gI"         = { action = "implementation"; desc = "Go to implementation"; };
        "K"          = { action = "hover";          desc = "Hover docs"; };
        "<leader>ca" = { action = "code_action";    desc = "Code action"; };
        "<leader>rn" = { action = "rename";         desc = "Rename symbol"; };
        "<leader>cf" = { action = "format";         desc = "Format buffer"; };
      };
    };
  };
}