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
            purple: #876FBE
        */

        base16Scheme = {
            # Backgrounds
            base00 = "222023"; # background #222023
            base01 = "322F33"; # lighter bg #322F33
            base02 = "3F3C41"; # selection bg #3F3C41
            base03 = "545255"; # comments #545255

            # Foregrounds
            base04 = "908D91"; # dark fg #908D91
            base05 = "F7F5F5"; # foreground #F7F5F5
            base06 = "EDE9F2"; # light fg #EDE9F2
            base07 = "F5F2FA"; #lightest fg #F5F2FA

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