{ host, lib, pkgs, inputs, config, ... }:
{
    imports = [
        inputs.dms.homeModules.dank-material-shell
    ];

    home.file.".config/DankMaterialShell/chan-theme.json".text = builtins.toJSON {
        dark = {
            name = "Chan";
            primary = "#876FBE";
            primaryText = "#F7F5F5";
            primaryContainer = "#453371";
            secondary = "#A18ECC";
            surfaceTint = "#876FBE";
            surface = "#222023";
            surfaceText = "#F7F5F5";
            surfaceVariant = "#262427";
            surfaceVariantText = "#B7B5B5";
            surfaceContainer = "#2A282B";
            surfaceContainerHigh = "#2E2C2F";
            surfaceContainerHighest = "#373538";
            background = "#1b191c";
            backgroundText = "#F7F5F5";
            outline = "#545255";
            error = "#C91931";
            warning = "#F18C58";
            info = "#A18ECC";
            matugen_type = "scheme-tonal-spot";
        };
    };

    programs.dank-material-shell = {
        enable = true;
        quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;

        systemd = {
            enable = true;              # Systemd service for auto-start
            restartIfChanged = true;    # Auto-restart dms.service when dms-shell changes
        };
        
        # Core features
        enableSystemMonitoring = true;  # System monitoring widgets (dgop)
        enableVPN = true;               # VPN management widget
        enableDynamicTheming = false;    # Wallpaper-based theming (matugen)
        enableAudioWavelength = true;   # Audio visualizer (cava)
        enableCalendarEvents = true;    # Calendar integration (khal)

        settings = {
            # Appearance
            currentThemeName = "custom";
            customThemeFile = "${config.home.homeDirectory}/.config/DankMaterialShell/chan-theme.json";
            popupTransparency = 0.7;
            cornerRadius = 14;
            fontFamily = "Noto Sans";
            monoFontFamily = "FiraCode Nerd Font Mono";
            fontScale = 1.01;

            # Clock
            use24HourClock = false;
            showSeconds = true;
            clockDateFormat = "ddd MMM d";

            # Weather
            weatherEnabled = true;
            weatherLocation = "Charlotte, NC";
            weatherCoordinates = "35.2272086, -80.8430827";
            useFahrenheit = true;

            # Workspace
            showWorkspaceApps = true;

            # Spotlight / Launcher
            spotlightModalViewMode = "grid";
            launcherLogoMode = "os";
            launcherLogoColorOverride = "primary";
            launcherLogoSizeOffset = 2;

            # Control Center Widgets
            controlCenterWidgets = [
                { id = "volumeSlider"; enabled = true; width = 50; }
                { id = "brightnessSlider"; enabled = true; width = 50; }
                { id = "wifi"; enabled = true; width = 50; }
                { id = "bluetooth"; enabled = true; width = 50; }
                { id = "audioOutput"; enabled = true; width = 50; }
                { id = "audioInput"; enabled = true; width = 50; }
            ];

            # Bar Configuration
            barConfigs = [{
                id = "default";
                name = "Main Bar";
                enabled = true;
                
                position = 0;
                exclusiveZone = true;
                hideOnFullscreen = true;

                leftWidgets = [
                    { id = "launcherButton"; enabled = true; }
                    { id = "workspaceSwitcher"; enabled = true; }
                    { id = "music"; enabled = true; }
                ];
                centerWidgets = [
                    { id = "clock"; enabled = true; }
                ];
                rightWidgets = [
                    { id = "systemTray"; enabled = true; }
                    { id = "notificationButton"; enabled = true; }
                ] ++ lib.optionals (host == "laptop") [
                    { id = "memUsage"; enabled = true; }
                    { id = "battery"; enabled = true; }
                ] ++ [
                    {
                        id = "controlCenterButton";
                        enabled = true;
                        showNetworkIcon = true;
                        showAudioIcon = true;
                        showBatteryIcon = false;
                        showBluetoothIcon = false;
                        showBrightnessIcon = false;
                        showMicIcon = false;
                        showPrinterIcon = false;
                        showVpnIcon = false;
                    }
                ];

                innerPadding = 2;
                transparency = 0.75;
                widgetTransparency = 0.6;

                gothCornersEnabled = true;
                gothCornerRadiusValue = 13;

                fontScale = 1.02;

                popupGapsAuto = true;
                popupGapsManual = 4;

                scrollEnabled = false;
                scrollYBehavior = "none";
            }];

            configVersion = 5;
        };
        
        /*
        clsettings = {
            maxHistory = false;
            maxEntrySize = 10485760;
            autoClearDays = 7;
            clearAtStartup = false;
            disabled = false;
        };*/

        session = {

        };
    };
}