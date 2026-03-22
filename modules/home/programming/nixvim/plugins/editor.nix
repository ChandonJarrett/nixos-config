{ ... }: {
  programs.nixvim.plugins = {

    # Auto-close brackets, quotes, parens
    nvim-autopairs = {
      enable = true;
      settings.check_ts = true;  # Use treesitter for smarter pairing
    };

    # gcc to comment a line, gc in visual mode to comment selection
    comment = {
      enable = true;
    };

    # Highlight TODO: FIXME: NOTE: HACK: etc. in comments
    todo-comments = {
      enable = true;
      settings.signs = true;
    };

    # Indent guides
    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "│";
        scope.enabled = true;  # Highlight the current scope's indent level
      };
    };
  };

  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader>ft"; action = "<cmd>TodoTelescope<cr>"; options.desc = "Find TODOs"; }
  ];
}