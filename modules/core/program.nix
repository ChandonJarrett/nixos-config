{ pkgs, ... }:
{
	programs = {
		dconf.enable = true;

		gnupg.agent = {
			enable = true;
			enableSSHSupport = true;
			# pinentryFlavor = "";
		};
		
		fish = {
			enable = true;
			interactiveShellInit = ''
				set fish_greeting
			'';
			shellAliases = {
				config = "cd ~/nixos-config";
			};
		};

		firefox = {
			enable = true;
			preferences = {
				"layout.css.devPixelsPerPx" = "1.3";
			};

			policies = {
				DisableTelemetry = true;
			};
		};

		
	};
}
