# agenix secrets

Encrypted secrets for this flake, decrypted at boot with the machine's SSH
host key (`/etc/ssh/ssh_host_ed25519_key`). `.age` files are safe to commit —
only the holder of the private key (i.e. the machine itself) can read them.

## Layout

- `userPassword.<hostname>.age` — sha-512 hash of the user's password, used via
  `users.users.<name>.hashedPasswordFile`. Falls back to
  `preferences.user.initialPassword` if the file for the current host doesn't
  exist yet.

Each machine needs its own file, because a secret encrypted for one host's key
cannot be decrypted by the other.

## Generate / rotate the password secret

Run **on the target machine** (this hashes the password, then encrypts it for
that machine's host key):

```console
$ ./.agenix/rotate-password.sh
```

The script prompts for the new password, writes
`userPassword.<hostname>.age`, and verifies it by decrypting.

Manual equivalent (uses this flake's own nixpkgs via the `mkpasswd` / `age`
package outputs, so it matches the script exactly):

```console
$ HASH=$(printf '%s' '<password>' | nix run .#mkpasswd -- -s -m sha-512)
$ printf '%s' "$HASH" | nix run .#age -- \
    -o ".agenix/userPassword.$(hostname).age" \
    -r "$(cat /etc/ssh/ssh_host_ed25519_key.pub)"
```

Then **git-add the new file** and rebuild — Nix flakes only see git-tracked
files, so an untracked `.age` file is invisible to evaluation:

```console
$ git add .agenix/userPassword.<hostname>.age
$ sudo nixos-rebuild switch --flake .#<host>
```

## Notes

- Decrypted secrets live in `/run/agenix/` (tmpfs) — nothing secret lands in
  `/nix/store`.
- **If you ever regenerate the machine's SSH host keys, every `.age` secret
  becomes undecryptable.** Keep a backup of `/etc/ssh/ssh_host_ed25519_key`
  (or re-run `rotate-password.sh` on each machine afterwards).
- After first login, still run `passwd` to change away from the bootstrap
  password if you haven't already.
- If a host has no secret file yet, it falls back to
  `preferences.user.initialPassword`; `nixos-rebuild` prints a warning if
  neither is configured (the account would have no password).
