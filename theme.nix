let
  palette = {
    base00 = "#18151f"; # bg
    base01 = "#201d28"; # light bg
    base02 = "#2d2a38"; # selection bg
    base03 = "#504b60"; # comments
    base04 = "#706a82"; # dark fg
    base05 = "#9890ac"; # fg
    base06 = "#bab4cc"; # light fg
    base07 = "#d8d2e8"; # lightest fg
    base08 = "#e0507a"; # red (errors, git deletion)
    base09 = "#e89060"; # orange (numbers, constants)
    base0A = "#d4a840"; # yellow (classes, warnings)
    base0B = "#78c4a0"; # green (strings, success)
    base0C = "#58b8d0"; # cyan (regex, escape chars)
    base0D = "#9d84e8"; # purple-blue (functions)
    base0E = "#c896f0"; # magenta (keywords)
    base0F = "#c06858"; # rust (deprecated, embedded langs)
  };

  semantic = {
    background = palette.base00;
    backgroundAlt = palette.base01;
    selection = palette.base02;
    muted = palette.base03;
    foregroundMuted = palette.base04;
    foreground = palette.base05;
    foregroundBright = palette.base07;

    error = palette.base08;
    warning = palette.base0A;
    success = palette.base0B;
    info = palette.base0C;
    accent = palette.base0D;
    accentAlt = palette.base0E;
  };

  ui = {
    gtk = {
      themeName = "Orchis-Purple-Dark";
      iconThemeName = "Papirus-Dark";
      iconColor = "violet";
      cursorName = "Bibata-Modern-Ice";
      cursorSize = 18;
    };

    starship = {
      purpleBright = "#c4b0f0";
      purpleDark = "#4a3278";
      purpleDeep = "#261945";
    };

    noctalia = {
      mError = semantic.error;
      mHover = semantic.success;
      mOnError = palette.base00;
      mOnHover = palette.base00;
      mOnPrimary = palette.base00;
      mOnSecondary = palette.base00;
      mOnSurface = semantic.foregroundBright;
      mOnSurfaceVariant = semantic.foregroundMuted;
      mOnTertiary = palette.base00;
      mOutline = semantic.muted;
      mPrimary = semantic.accent;
      mSecondary = semantic.accentAlt;
      mShadow = palette.base00;
      mSurface = semantic.background;
      mSurfaceVariant = semantic.backgroundAlt;
      mTertiary = semantic.info;
    };
  };

  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;

  paletteNoHash = builtins.mapAttrs (_: v: stripHash v) palette;
  semanticNoHash = builtins.mapAttrs (_: v: stripHash v) semantic;
in {
  flake.theme = {
    inherit palette paletteNoHash semantic semanticNoHash ui;
  };
}