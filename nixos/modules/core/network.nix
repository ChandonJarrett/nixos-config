{...}: {
  flake.nixosModules.network = {pkgs, ...}: {
    networking = {
      networkmanager.enable = true;
      # DNS comes from DHCP/NetworkManager so split-DNS, VPN and Tailscale
      # (MagicDNS) keep working; hardcoded upstreams broke those.
      firewall = {
        enable = true;
        allowedTCPPorts = [
          22 # SSH (key-only; fail2ban)
        ];
      };
    };

    environment.systemPackages = [
      pkgs.networkmanagerapplet
    ];
  };
}
