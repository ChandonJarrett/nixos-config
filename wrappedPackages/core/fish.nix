{
  inputs,
  lib,
  config,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    theme = config.flake.theme.palette;

    lf = self'.packages.lf;
    starship = self'.packages.starship;
    neovim = self'.packages.neovim;

    fishConf = pkgs.writeText "fish-config" ''
      if not status is-interactive
        exit
      end

      set -g fish_greeting

      set -gx EDITOR "${lib.getExe neovim}"
      set -gx VISUAL "$EDITOR"

      set -gx PAGER less
      set -gx LESS "-R --mouse --wheel-lines=3"
      set -gx LESSHISTFILE -
      set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

      set -gx XDG_CONFIG_HOME "$HOME/.config"
      set -gx XDG_CACHE_HOME "$HOME/.cache"
      set -gx XDG_DATA_HOME "$HOME/.local/share"

      set -gx NIX_CONFIG "extra-experimental-features = nix-command flakes"

      set -gx BASE16_BACKGROUND "${theme.base00}"
      set -gx BASE16_FOREGROUND "${theme.base05}"
      set -gx BASE16_CURSOR "${theme.base07}"

      function fish_user_key_bindings
        fish_vi_key_bindings
        bind -M insert \cf accept-autosuggestion
        bind -M insert \cr history-pager
      end

      ${lib.getExe starship} init fish | source
      ${lib.getExe pkgs.zoxide} init fish --cmd cd | source

      type -q direnv; and direnv hook fish | source

      if type -q fzf
        set -gx FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --exclude .git"

        set -gx FZF_DEFAULT_OPTS "
          --height=40%
          --layout=reverse
          --border=rounded
          --prompt=' '
          --pointer=''
          --marker='●'
          --color=bg:${theme.base00},fg:${theme.base05}
          --color=bg+:${theme.base01},fg+:${theme.base07}
          --color=hl:${theme.base0D},hl+:${theme.base0E}
          --color=prompt:${theme.base0A},pointer:${theme.base0C},marker:${theme.base0B}
        "
      end

      set -gx BAT_THEME "base16"

      set -gx DELTA_FEATURES "decorations"
      set -gx DELTA_NAVIGATE true
      set -gx DELTA_LINE_NUMBERS true
      set -gx DELTA_THEME "base16"

      type -q eza; and begin
        alias ls "eza --icons --group-directories-first"
        alias ll "eza -lah --icons --group-directories-first --git"
        alias la "eza -a --icons"
        alias lt "eza --tree --level=2 --icons"
      end

      alias ll "ls -lah"
      alias la "ls -a"

      type -q bat; and alias cat "bat --style=plain --paging=never"

      alias v "$EDITOR"
      alias vi "$EDITOR"
      alias vim "$EDITOR"
      alias nvim "$EDITOR"

      abbr -a g git
      abbr -a gs git status --short --branch
      abbr -a ga git add
      abbr -a gaa git add --all
      abbr -a gc git commit
      abbr -a gcm git commit -m
      abbr -a gp git push
      abbr -a gpl git pull
      abbr -a gd git diff
      abbr -a gds git diff --staged
      abbr -a gl git log --oneline --graph --decorate --all

      abbr -a nr nix run
      abbr -a nd nix develop
      abbr -a ns nix shell
      abbr -a nf nix flake
      abbr -a nfu nix flake update
      abbr -a nfc nix flake check
      abbr -a nb nix build
      abbr -a nrpl nix repl

      abbr -a c clear
      abbr -a q exit
      abbr -a mkdir mkdir -p
      abbr -a grep rg
      abbr -a find fd

      abbr -a .. cd ..
      abbr -a ... cd ../..
      abbr -a .... cd ../../..

      function lf --wraps="${lib.getExe lf}"
        set -l dir (${lib.getExe lf} -print-last-dir $argv)
        test -n "$dir"; and test "$dir" != (pwd); and cd "$dir"
      end

      function zi
        type -q zoxide; and type -q fzf; or return
        set -l dir (zoxide query -l | fzf)
        test -n "$dir"; and cd "$dir"
      end

      function mkcd
        test (count $argv) -eq 0; and echo "usage: mkcd <dir>"; and return 1
        mkdir -p "$argv[1]"; and cd "$argv[1]"
      end

      function extract
        test (count $argv) -eq 0; and echo "usage: extract <file>"; and return 1

        switch $argv[1]
          case "*.tar.gz" "*.tgz"
            tar xzf $argv[1]
          case "*.tar.bz2"
            tar xjf $argv[1]
          case "*.tar"
            tar xf $argv[1]
          case "*.zip"
            unzip $argv[1]
          case "*.7z"
            7z x $argv[1]
          case "*.gz"
            gunzip $argv[1]
          case "*.bz2"
            bunzip2 $argv[1]
          case "*.rar"
            unrar x $argv[1]
          case "*"
            echo "Unsupported: $argv[1]"
            return 1
        end
      end
    '';
  in {
    packages.fish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;

      runtimeInputs = with pkgs; [
        zoxide
        starship
        direnv
        fzf
        fd
        ripgrep
        bat
        eza
        jq
        delta
        unzip
        p7zip
        unrar
        less
      ];

      flags = {
        "-C" = "source ${fishConf}";
      };
    };
  };
}