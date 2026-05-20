# NixOS flake: Hyprland daily driver

Declarative NixOS configuration for daily use and development. This repo is intended to live at `/home/<user>/nixos-config`.

## Highlights

- Hyprland + Noctalia Shell
- Fish + Kitty + Starship wrapped as self-contained packages
- Hjem for declarative user files
- Sensible defaults for desktop, audio, networking, and services

## Quick start

1. Place the repo at `/home/<user>/nixos-config`.
2. Pick a host under `nixos/hosts/` and update:
   - `networking.hostName`
   - `system.stateVersion`
   - `preferences.user.name`, `preferences.user.fullName`, `preferences.user.email`
   - `preferences.user.initialPassword`
   - `preferences.monitors` (if needed)
   - `preferences.apps.*` (optional toggles)
3. Rebuild and switch:

```
sudo nixos-rebuild switch --flake .#<host>
```

4. On first login, change the password:

```
passwd
```

## Structure

```
.
├── flake.nix
├── parts.nix
├── theme.nix
├── nixos/
│   ├── hosts/              # Host definitions + hardware configs
│   └── modules/
│       ├── core/           # Core system modules (desktop, nix, services, etc.)
│       ├── apps/           # App modules (browsers, editors, etc.)
│       └── helpers/        # Helper modules (preferences, Hjem, Hyprland helpers)
└── wrappedPackages/        # Wrapped packages and shell environment
```

## Wrapped packages

- `environment`: primary shell with runtime tools and `EDITOR` set to Neovim
- `fish`: Fish with vi bindings, zoxide, starship, direnv hook, and an `lf` wrapper
- `kitty`: theme-driven Kitty config with shell integration
- `lf`: file manager with a minimal config and directory jump
- `starship`: themed prompt
- `noctalia-shell`: wrapper for Noctalia with a basic bar layout

## Documentation

- `nixos/hosts/README.md`: host structure and adding new hosts
- `nixos/modules/README.md`: module layout and conventions

## Maintenance

Update inputs:

```
nix flake update
```
