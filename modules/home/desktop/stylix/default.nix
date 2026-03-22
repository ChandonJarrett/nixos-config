{ inputs, pkgs, ... }:
{
    imports = [
        inputs.stylix.homeModules.stylix
    ];

    stylix = {
        enable = true;

        autoEnable = true;
        targets = {
            starship.enable = false;
        };

        polarity = "dark";

        # image = ; # wallpaper

        /* 
        base colors:
            black: #222023
            white: #F7F5F5
            gray: #545255
            
            orange: #F18C58
            red: #C91931
            purple: #
            
        */

        base16Scheme = {
            # Backgrounds
            base00 = "1b191c"; # background #1b191c
            base01 = "222023"; # lighter bg #222023
            base02 = "2E2C2F"; # selection bg #2E2C2F
            base03 = "545255"; # comments #545255

            # Foregrounds
            base04 = "767477"; # dark fg #767477
            base05 = "908d91"; # foreground #908d91
            base06 = "b3adb6"; # light fg #b3adb6
            base07 = "ccc5d0"; #lightest fg #ccc5d0

            base08 = "C91931"; # red #C91931
            base09 = "F18C58"; # orange #F18C58
            base0A = "D4A030"; # yellow #D4A030
            base0B = "6BAF92"; # green #6BAF92
            base0C = "4FA8C0"; # cyan #4FA8C0
            base0D = "876FBE"; # blue #876FBE
            base0E = "A18ECC"; # purple #A18ECC
            base0F = "9E3B1A"; # brown #9E3B1A
        };


        opacity = {
            desktop = 0.75;
            popups = 0.70;
            applications = 0.70;
            terminal = 0.65;
        };

        fonts = {
            serif = {
                package = pkgs.noto-fonts;
                name = "Noto Serif";
            };

            sansSerif = {
                package = pkgs.noto-fonts;
                name = "Noto Sans";
            };

            monospace = {
                package = pkgs.nerd-fonts.fira-code;
                name = "FiraCode Nerd Font Mono";
            };

            sizes = {
                desktop = 10;
                popups = 10;
                applications = 12;
                terminal = 12;
            };
        };

        icons = {
            enable = true;
            package = pkgs.papirus-icon-theme;
            dark = "Papirus-Dark";
        };

        cursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Ice";
            size = 18;
        };
    };
}