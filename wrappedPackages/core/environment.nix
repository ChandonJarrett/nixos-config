{
  lib,
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.terminal =
      (inputs.wrappers.wrapperModules.kitty.apply {
        inherit pkgs;
        imports = [self.wrappersModules.kitty];
        shell = lib.getExe self'.packages.environment;
      }).wrapper;

    packages.environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;

      runtimeInputs = [
        # nix tooling lives in nixos/modules/core/nix.nix (systemPackages);
        # only deadnix stays here (used by the shell linters, not duplicated
        # there).
        pkgs.deadnix

        # shell / cli basics
        pkgs.file
        pkgs.which
        pkgs.less
        pkgs.unzip
        pkgs.zip
        pkgs.p7zip
        pkgs.wget
        pkgs.curl
        pkgs.killall
        pkgs.jq
        pkgs.yq
        pkgs.tree

        # search / navigation
        pkgs.fzf
        pkgs.zoxide
        pkgs.eza
        pkgs.fd
        pkgs.ripgrep
        pkgs.dust
        pkgs.duf

        # monitoring
        pkgs.btop

        # git
        pkgs.git
        pkgs.delta
        pkgs.gitui

        # formatters / linters
        pkgs.stylua
        pkgs.shfmt
        pkgs.shellcheck
        pkgs.taplo
        pkgs.ruff
        pkgs.prettier

        # language servers
        pkgs.lua-language-server
        pkgs.bash-language-server
        pkgs.vscode-langservers-extracted
        pkgs.yaml-language-server
        pkgs.marksman
        pkgs.pyright

        # container orchestration
        pkgs.docker-compose

        # wrapped
        self'.packages.neovim
        self'.packages.lf
        self'.packages.nix-check-bin
      ];

      env = {
        EDITOR = lib.getExe self'.packages.neovim;
        VISUAL = lib.getExe self'.packages.neovim;
        PAGER = "less";
        LESS = "-R --mouse --wheel-lines=3";
        LESSHISTFILE = "-";
        NIX_CONFIG = "extra-experimental-features = nix-command flakes";
      };
    };

    packages.nix-check-bin = pkgs.writeShellApplication {
      name = "nix-check-bin";

      runtimeInputs = [
        pkgs.nix
        self'.packages.neovim
      ];

      text = ''
        if [ "$#" -ne 1 ]; then
          echo "usage: nix-check-bin <flake-installable>"
          exit 1
        fi

        "$EDITOR" "$(nix build "$1" --no-link --print-out-paths)/bin"
      '';
    };
  };
}
