{ ... }: {
  programs.nixvim.plugins.oil = {
    enable = true;
    settings = {
      view_options.show_hidden = true;  # Show dotfiles
      delete_to_trash = true;
    };
  };

  programs.nixvim.keymaps = [
    # Press - to open the directory of the current file (or parent dir)
    { mode = "n"; key = "-"; action = "<cmd>Oil<cr>"; options.desc = "Open parent dir (Oil)"; }
  ];
}