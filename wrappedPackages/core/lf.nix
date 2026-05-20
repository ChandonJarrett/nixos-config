{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    conf =
      pkgs.writeText "lf-config"
      # bash
      ''
        # UI
        set reverse true
        set preview true
        set hidden true
        set drawbox true
        set icons true
        set ignorecase true
        set number true
        set relativenumber true
        set ratios 1:2:3
        set info size:time
        set period 1
        set scrolloff 8
 
        # Sorting
        set sortby natural
        setlocal ~/Downloads/ sortby time
        setlocal ~/Downloads/ reverse true

        # Shell
        set shell fish
        set ifs "\n"

        # Open files with xdg-open when possible
        cmd open &{{
          case "$(file --mime-type -Lb "$f")" in
            text/*|application/json|application/xml|application/x-shellscript)
              ''${EDITOR:-nvim} "$f"
              ;;
            *)
              xdg-open "$f" >/dev/null 2>&1 &
              ;;
          esac
        }}

        # Safer delete: trash if available, otherwise prompt rm
        cmd trash &{{
          printf "Delete permanently? [y/N] "
          read ans
          test "$ans" = y && rm -rf -- "$fx"
        }}

        # Convenience commands
        cmd mkdir %{{
          printf "Directory name: "
          read name
          mkdir -p "$name"
        }}

        cmd touch %{{
          printf "File name: "
          read name
          touch "$name"
        }}

        cmd extract &{{
          case "$f" in
            *.tar.bz2) tar xjf "$f" ;;
            *.tar.gz)  tar xzf "$f" ;;
            *.bz2)     bunzip2 "$f" ;;
            *.rar)     unrar x "$f" ;;
            *.gz)      gunzip "$f" ;;
            *.tar)     tar xf "$f" ;;
            *.tbz2)    tar xjf "$f" ;;
            *.tgz)     tar xzf "$f" ;;
            *.zip)     unzip "$f" ;;
            *.7z)      7z x "$f" ;;
            *)         echo "Unsupported archive: $f" ;;
          esac
        }}

        # Keymaps
        map . set hidden!
        map r reload
        map o open
        map x trash
        map a touch
        map A mkdir
        map E extract

        # Navigation
        map gh cd ~
        map gd cd ~/Downloads
        map gc cd ~/.config
        map gp cd ~/Projects
        map gr cd /

        # Shell actions
        map e $$EDITOR "$f"
        map v $$EDITOR "$f"
        map y %printf "$fx" | wl-copy
        map Y %printf "$pwd" | wl-copy
      '';
  in {
    packages.lf = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.lf;

      runtimeInputs = with pkgs; [
        file
        xdg-utils
        unzip
        p7zip
        unrar
        trash-cli
        wl-clipboard
      ];

      flags = {
        "-config" = "${conf}";
      };
    };
  };
}