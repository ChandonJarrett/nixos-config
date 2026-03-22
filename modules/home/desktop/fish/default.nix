{ lib, ... }:
{
    programs.fish = {
        enable = true;

        interactiveShellInit = ''
            
        '';
    };

    programs.starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {
            add_newline = true;

            palette = "chan";

            format = lib.replaceStrings ["\n"] [""] ''
            [╭─](bold light_purple)
            [](dark-gray)
            [](bold fg:light_purple bg:dark-gray)
            [ ](fg:dark-gray bg:purple)
            $directory
            [ ](fg:purple bg:dark_purple)
            $git_branch
            $git_status
            [ ](fg:dark_purple bg:darkest_purple)
            [ ](fg:darkest_purple)
            $fill
            $cmd_duration
            $line_break
            [╰─](bold light_purple)
            $character
            '';

            # $nodejs\
            # $rust\
            #$golang\
            #$python\
            #$cpp\

            fill.symbol = " ";

            direnv.disabled = true;
            package.disabled = true;

            character = {
                success_symbol = "[](bold light_purple)";
                error_symbol = "[](bold orange)";
            };

            directory = {
                format = "[$path](fg:white bg:purple)";
                truncation_symbol = "./";
                truncation_length = 3;
            };

            cmd_duration = {
                format = "[ $duration](bold fg:purple)";
                show_milliseconds = true;
            };


            # Git Stuff

            git_branch = {
                symbol = "";
                format = "[$symbol $branch(:$remote_branch)](bold fg:light_purple bg:dark_purple)";
            };

            git_status = {
                format = "[$all_status$ahead_behind](bold fg:light_purple bg:dark_purple)";
            };

            # Languages Stuff



            
            # Theme Stuff

            palettes.chan = {
                black = "#222023";
                dark-gray = "#343135";
                gray = "#545255";
                light-gray = "#908d91";
                white = "#f7f5f5";

                orange = "#fa7e37";

                light_purple = "#a18ecc";
                purple = "#876fbe";
                dark_purple = "#453371";
                darkest_purple = "#231938";

            };
        };
    };
}