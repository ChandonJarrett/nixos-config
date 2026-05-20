{
  inputs,
  ...
}: {
  perSystem = { pkgs, ... }: {
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      package = pkgs.noctalia-shell;

      env = {
        NOCTALIA_CACHE_DIR = "/tmp/noctalia-cache";
      };

      settings = {
        appLauncher = {
          position = "center";
          terminalCommand = "kitty -e";
          viewMode = "grid";
        };

        bar = {
          position = "top";

          floating = true;
          marginVertical = 8;
          marginHorizontal = 12;

          density = "default";
          showCapsule = true;
          showOutline = false;

          backgroundOpacity = 0.72;
          capsuleOpacity = 0.8;

          outerCorners = true;
          exclusive = true;

          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "Workspace";
                labelMode = "none";
                showApplications = false;
              }
              {
                id = "ActiveWindow";
              }
            ];

            center = [
              {
                id = "Clock";
                formatHorizontal = "MMM d  •  h:mm a";
                formatVertical = "MMM d\nh:mm a";
                usePrimaryColor = true;
              }
            ];

            right = [
              {
                id = "MediaMini";
              }
              {
                id = "Network";
              }
              {
                id = "Volume";
              }
              {
                id = "Brightness";
              }
              {
                id = "Battery";
              }
              {
                id = "NotificationHistory";
                showUnreadBadge = true;
              }
              {
                id = "Tray";
                drawerEnabled = true;
              }
            ];
          };
        };

        general = {
          scaleRatio = 1;

          radiusRatio = 1.1;
          boxRadiusRatio = 1.1;
          screenRadiusRatio = 1;

          animationSpeed = 1;
          animationDisabled = false;

          enableShadows = true;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;

          showScreenCorners = false;
          forceBlackScreenCorners = false;
        };

        ui = {
          fontDefault = "JetBrainsMono Nerd Font";
          fontFixed = "JetBrainsMono Nerd Font";

          panelBackgroundOpacity = 0.75;
          panelsAttachedToBar = true;
          settingsPanelMode = "attached";

          tooltipsEnabled = true;
          boxBorderEnabled = false;
        };

        location = {
          name = "Charlotte";
          weatherEnabled = true;
          weatherShowEffects = true;

          useFahrenheit = true;
          use12hourFormat = true;

          hideWeatherTimezone = true;
          hideWeatherCityName = false;
        };

      };
    };
  };
}