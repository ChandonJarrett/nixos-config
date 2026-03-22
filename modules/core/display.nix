{ pkgs, inputs, username, ... }:
{
	# WAYLAND
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
		withUWSM = true;
		package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; 
	};

	xdg.portal = {
		enable = true;
		xdgOpenUsePortal = true;
		config = {
			common.default = [ "gtk" ];
			hyprland.default = [
				"gtk"
				"hyprland"
			];
		};
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	};

	# XSERVER
	services = {
		xserver = {
			enable = true;
			xkb.layout = "us";
			xkb.options = "caps:escape"; # Caps Lock = Escape key
		};
	
		displayManager.autoLogin = {
			enable = true;
			user = username;
		};
		libinput = {
			enable = true;
		};
	};

	systemd.settings.Manager.DefaultTimeoutStopSec = "10s"; # prevent getting stuck at shutdown.
}
