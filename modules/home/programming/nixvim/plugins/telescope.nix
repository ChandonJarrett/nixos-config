{ ... }: {
  programs.nixvim.plugins.web-devicons.enable = true;  # Filetype icons for telescope

  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions.fzf-native.enable = true;  # Much faster fuzzy matching
  };

  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader><space>"; action = "<cmd>Telescope find_files<cr>";  options.desc = "Find files"; }
    { mode = "n"; key = "<leader>ff";      action = "<cmd>Telescope find_files<cr>";  options.desc = "Find files"; }
    { mode = "n"; key = "<leader>fg";      action = "<cmd>Telescope live_grep<cr>";   options.desc = "Live grep"; }
    { mode = "n"; key = "<leader>fb";      action = "<cmd>Telescope buffers<cr>";     options.desc = "Buffers"; }
    { mode = "n"; key = "<leader>fr";      action = "<cmd>Telescope oldfiles<cr>";    options.desc = "Recent files"; }
    { mode = "n"; key = "<leader>fh";      action = "<cmd>Telescope help_tags<cr>";   options.desc = "Help tags"; }
    { mode = "n"; key = "<leader>fd";      action = "<cmd>Telescope diagnostics<cr>"; options.desc = "Diagnostics"; }
  ];
}