# Modules

Modules are grouped by purpose and composed by hosts.

## Layout

- `core/`: system foundations (system, locale, users, devtools, desktop, nix, networking, services, shell)
- `apps/`: optional application modules — firefox, helium, gimp, obsidian, vscode,
  youtube-music, virtualization, gaming (toggle via `preferences.apps.*`)
- `helpers/`: small utilities and shared options used by core and hosts

## Conventions

- Keep modules focused and reusable.
- Avoid host-specific settings inside modules.
- Use the preferences layer in `helpers/base` for user-specific and host-specific values.
  Notable toggles: `preferences.devtools.*` (toolchains, off by default — opt in per
  host), `preferences.services.printing`, `preferences.hardware.bluetooth`.
- Secrets are declared in `secrets.nix` (repo root) and consumed via `config.age.*`;
  see `.agenix/README.md`.
