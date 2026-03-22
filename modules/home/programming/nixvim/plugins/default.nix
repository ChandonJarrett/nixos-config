{ ... }: {
  imports = [
    ./treesitter.nix
    ./telescope.nix
    ./lsp.nix
    ./blink-cmp.nix
    ./which-key.nix
    ./gitsigns.nix
    ./lualine.nix
    ./oil.nix
    ./editor.nix
  ];
}