{...}: {
  flake.nixosModules.helium = {
    pkgs,
    config,
    lib,
    ...
  }: let
    version = "0.15.1.1";

    # Upgrade: bump `version`, then refresh the hash with:
    #   nix-prefetch-url "https://github.com/imputnet/helium-linux/releases/download/<ver>/helium-<ver>-x86_64_linux.tar.xz"
    src = pkgs.fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
      sha256 = "sha256-1RrtHYW5TwBhINTu22JSd4KjnxORlDK/77u1pElddZo=";
    };

    appDir = pkgs.runCommand "helium-appdir" {} ''
      mkdir -p $out
      tar -xJf ${src} --strip-components=1 -C $out
    '';

    helium = pkgs.buildFHSEnv {
      name = "helium";
      targetPkgs = p:
        with p; [
          gtk3
          glib
          pango
          cairo
          gdk-pixbuf
          nss
          nspr
          alsa-lib
          libglvnd
          libxkbcommon
          fontconfig
          freetype
          dbus
          at-spi2-core
          libpulseaudio
          xdg-utils
          zlib
          expat
          libX11
          libxcb
          libXcomposite
          libXdamage
          libXext
          libXfixes
          libXrandr
          libxshmfence
          libXi
          libXtst
          libXrender
          libXScrnSaver
          libdrm
          mesa
          libgbm
          libudev-zero
          libva
          libvdpau
          cups
          libsecret
          libnotify
          libevent
        ];
      runScript = "${appDir}/helium-wrapper";
    };

    # Resolve the icon at build time so a renamed asset fails loudly instead
    # of silently producing a broken desktop entry. (Create $out explicitly —
    # runCommand builders in this environment must make their own output dir,
    # same as the appDir extraction above.)
    iconDir = pkgs.runCommand "helium-icon" {} ''
      mkdir -p "$out"
      logo="$(find ${appDir} -maxdepth 1 -name 'product_logo_*.png' | head -n1)"
      [[ -n "$logo" ]] || { echo "helium icon not found in appdir" >&2; exit 1; }
      cp "$logo" "$out/product_logo.png"
    '';
    icon = "${iconDir}/product_logo.png";

    desktopItem = pkgs.makeDesktopItem {
      name = "helium";
      desktopName = "Helium";
      genericName = "Web Browser";
      exec = "helium %U";
      inherit icon;
      startupWMClass = "helium";
      categories = ["Network" "WebBrowser"];
      mimeTypes = ["text/html" "x-scheme-handler/http" "x-scheme-handler/https"];
    };
  in {
    config = lib.mkIf config.preferences.apps.helium {
      environment.systemPackages = [
        helium
        desktopItem
      ];
    };
  };
}
