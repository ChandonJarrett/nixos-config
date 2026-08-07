#!/usr/bin/env bash
# Regenerate the password secret for THIS host.
#
#   ./.agenix/rotate-password.sh
#
# Prompts for a new password, writes `userPassword.<hostname>.age` encrypted
# for this machine's SSH host key, and verifies it by decrypting.
set -euo pipefail
cd "$(dirname "$0")"

# Run tools from THIS flake's own nixpkgs (parts.nix packages) so the script
# is reproducible and works even when the nixpkgs registry is unavailable.
flake_dir="$(cd .. && pwd)"
host="$(hostname)"
key="/etc/ssh/ssh_host_ed25519_key"
out="userPassword.${host}.age"

if [[ ! -f "$key" ]]; then
  echo "error: no SSH host key at $key — cannot encrypt for this host." >&2
  exit 1
fi

read -r -s -p "New password: " pw; echo
read -r -s -p "Confirm password: " pw2; echo
[[ "$pw" == "$pw2" ]] || { echo "error: passwords do not match." >&2; exit 1; }
[[ -n "$pw" ]] || { echo "error: empty password." >&2; exit 1; }

# -s reads the password from stdin so mkpasswd doesn't print a stray prompt.
hash="$(printf '%s' "$pw" | nix run "$flake_dir"#mkpasswd -- -s -m sha-512)"

printf '%s' "$hash" | nix run "$flake_dir"#age -- -o "$out" -r "$(cat "$key.pub")"

echo "Wrote $out (encrypted for $host)."
echo "Remember to git-add it before rebuilding (flakes only see tracked files): git add $out"

# Flakes only see git-tracked files, so an untracked secret is invisible to
# evaluation — the host silently falls back to initialPassword (or no password).
# Catch that now instead of after a confusing rebuild.
if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if ! git ls-files --error-unmatch "$out" >/dev/null 2>&1; then
    echo "warning: $out is NOT tracked by git yet — the flake won't see it until you run:" >&2
    echo "  git add $out" >&2
  fi
fi

# The private key is root-readable only; decrypt verification is only possible
# as root (or at boot, when agenix runs as root).
if [[ -r "$key" ]]; then
  echo -n "Decrypt check: "
  nix run "$flake_dir"#age -- -d -i "$key" "$out" | head -c 8
  echo "... ok"
else
  echo "Note: $key is not readable by the current user, so the decrypt check was skipped."
  echo "Decryption is verified automatically at boot (agenix runs as root)."
fi
