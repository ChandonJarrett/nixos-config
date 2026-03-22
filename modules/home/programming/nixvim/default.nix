{ inputs, pkgs, ... }:
{
    imports = [
        inputs.nixvim.homeModules.nixvim
		./plugins
		./keymaps.nix
		./options.nix
    ];

	programs.nixvim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;

		globals = {
			mapleader = " ";
			maplocalleader = " ";
		};

		opts.clipboard = "unnamedplus";
	};
}
