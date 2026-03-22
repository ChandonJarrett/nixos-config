{ ... }: {
  programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add.text          = "▎";
        change.text       = "▎";
        delete.text       = "";
        topdelete.text    = "";
        changedelete.text = "▎";
      };
      current_line_blame = false;  # Set true to show inline git blame
    };
  };

  programs.nixvim.keymaps = [
    { mode = "n"; key = "]h"; action = "<cmd>Gitsigns next_hunk<cr>";    options.desc = "Next git hunk"; }
    { mode = "n"; key = "[h"; action = "<cmd>Gitsigns prev_hunk<cr>";    options.desc = "Prev git hunk"; }
    { mode = "n"; key = "<leader>gp"; action = "<cmd>Gitsigns preview_hunk<cr>"; options.desc = "Preview hunk"; }
    { mode = "n"; key = "<leader>gs"; action = "<cmd>Gitsigns stage_hunk<cr>";   options.desc = "Stage hunk"; }
    { mode = "n"; key = "<leader>gr"; action = "<cmd>Gitsigns reset_hunk<cr>";   options.desc = "Reset hunk"; }
    { mode = "n"; key = "<leader>gb"; action = "<cmd>Gitsigns blame_line<cr>";   options.desc = "Blame line"; }
  ];
}