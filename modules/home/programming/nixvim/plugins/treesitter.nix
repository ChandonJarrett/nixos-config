{ ... }: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;   # Vastly better syntax highlighting than regex
      indent.enable = true;      # Treesitter-aware indentation
    };
  };
}