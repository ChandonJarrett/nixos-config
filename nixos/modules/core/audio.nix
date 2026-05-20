{...}: {
  flake.nixosModules.audio = { ... }: {
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    hardware.alsa.enablePersistence = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}
