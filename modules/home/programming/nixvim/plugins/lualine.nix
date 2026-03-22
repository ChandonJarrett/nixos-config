{ ... }: {
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings.options = {
      theme = "auto";           # Picks up stylix colors automatically
      globalstatus = true;      # Single statusline across all splits (cleaner)
      component_separators = { left = ""; right = ""; };
      section_separators   = { left = ""; right = ""; };
    };
  };
}