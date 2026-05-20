# Hosts

Each host provides a `configuration.nix` and a `hardware-configuration.nix`. The flake exposes each host as `nixosConfigurations.<host>`.

## Adding a new host

1. Copy an existing host folder under `nixos/hosts/`.
2. Update `configuration.nix`:
   - `networking.hostName`
   - `system.stateVersion`
   - `preferences.user.name` / `preferences.user.fullName` / `preferences.user.email`
   - `preferences.user.initialPassword`
   - `preferences.monitors` (if needed)
   - `preferences.apps.*` (optional toggles)
3. Ensure the host imports the shared defaults, core system module, and its hardware file.
4. Rebuild:

```
sudo nixos-rebuild switch --flake .#<host>
```

## Shared defaults

`shared.nix` defines defaults used by all hosts, such as firmware and kernel settings.
