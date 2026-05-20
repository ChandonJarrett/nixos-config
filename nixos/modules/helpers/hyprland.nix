# Hyprland helpers: translate structured keymaps + settings into hyprland.conf
{lib, self, ...}: let
  inherit (self.lib.generators) toHyprconf;
in {
  flake.nixosModules.hyprland = {lib, config, pkgs, ...}: let
    user = config.preferences.user.name;
    cfg = config.home.programs.hyprland;
  in {
    options.home.programs.hyprland = {
      enable = lib.mkEnableOption "hyprland configuration";

      settings = lib.mkOption {
        default = {};
        description = ''
          Hyprland settings as an attrset that gets converted to hyprland.conf.
        '';
      };

      extraConfig = lib.mkOption {
        default = "";
        description = ''
          Extra raw Hyprland config appended at the end.
        '';
      };

      finalConfig = lib.mkOption {
        default = "";
      };
    };

    config = lib.mkIf cfg.enable {
      # Turn the settings attrset into hyprland.conf text.
      home.programs.hyprland.finalConfig = (toHyprconf {attrs = cfg.settings;}) + cfg.extraConfig;

      # Write the final config into the user's home.
      hjem.users.${user} = {
        files.".config/hypr/hyprland.conf".text = cfg.finalConfig;
      };

      # Map preferences.autostart to Hyprland exec-once lines.
      home.programs.hyprland.settings.exec-once = builtins.map (entry:
        if (builtins.typeOf entry) == "string"
        then lib.getExe (pkgs.writeShellScriptBin "autostart" entry)
        else lib.getExe entry)
      config.preferences.autostart;

      # Translate the structured keymap into Hyprland bind/submap syntax.
      home.programs.hyprland.extraConfig = let
        wrapWriteApplication = text:
          lib.getExe (pkgs.writeShellApplication {
            name = "script";
            text = text;
          });

        # Turns sane looking keymaps into Hyprland syntax:
        # "A" -> ",A" and "super + d" -> "super, d".
        sanitizeKeyName = keyName: let
          replaced = builtins.replaceStrings ["+"] [","] keyName;
        in
          if builtins.match ".*,.*" replaced != null
          then replaced
          else "," + replaced;

        makeHyprBinds = parentKeyName: keyName: keyOptions: let
          finalKeyName = sanitizeKeyName keyName;

          submapname =
            parentKeyName
            + (builtins.replaceStrings [" " "," "$" "+"] ["hypr" "submaps" "syntax" "suck"] finalKeyName);
        in
          if lib.isDerivation keyOptions
          then ''
            bind = ${finalKeyName}, exec, ${lib.getExe keyOptions}
            bind = ${finalKeyName},submap,reset
          ''
          else if builtins.hasAttr "exec" keyOptions
          then ''
            bind = ${finalKeyName}, exec, ${wrapWriteApplication keyOptions.exec}
            bind = ${finalKeyName},submap,reset
          ''
          else if builtins.hasAttr "package" keyOptions
          then ''
            bind = ${finalKeyName}, exec, ${lib.getExe keyOptions.package}
            bind = ${finalKeyName},submap,reset
          ''
          else ''
            bind = ${finalKeyName}, submap, ${submapname}

            submap = ${submapname}
            ${lib.concatLines (lib.mapAttrsToList (makeHyprBinds submapname) keyOptions)}
            submap = reset
          '';
      in
        lib.mkAfter (
          lib.concatLines (
            lib.mapAttrsToList (makeHyprBinds "root") config.preferences.keymap
          )
        );
    };
  };

  # Helper: convert attrsets into Hyprland config syntax.
  # Source adapted from home-manager Hyprland module.
  flake.lib.generators.toHyprconf = {attrs, indentLevel ? 0, importantPrefixes ? ["$" "bezier"],}: let
    inherit
      (lib)
      all
      concatMapStringsSep
      concatStrings
      concatStringsSep
      filterAttrs
      foldl
      generators
      hasPrefix
      isAttrs
      isList
      mapAttrsToList
      replicate
      ;

    initialIndent = concatStrings (replicate indentLevel "  ");

    toHyprconf' = indent: attrs: let
      sections = filterAttrs (n: v: isAttrs v || (isList v && all isAttrs v)) attrs;

      mkSection = n: attrs:
        if lib.isList attrs
        then (concatMapStringsSep "\n" (a: mkSection n a) attrs)
        else ''
          ${indent}${n} {
          ${toHyprconf' "  ${indent}" attrs}${indent}}
        '';

      mkFields = generators.toKeyValue {
        listsAsDuplicateKeys = true;
        inherit indent;
      };

      allFields = filterAttrs (n: v: !(isAttrs v || (isList v && all isAttrs v))) attrs;

      isImportantField = n: _:
        foldl (acc: prev:
          if hasPrefix prev n
          then true
          else acc)
        false
        importantPrefixes;

      importantFields = filterAttrs isImportantField allFields;

      fields = builtins.removeAttrs allFields (mapAttrsToList (n: _: n) importantFields);
    in
      mkFields importantFields
      + concatStringsSep "\n" (mapAttrsToList mkSection sections)
      + mkFields fields;
  in
    toHyprconf' initialIndent attrs;
}
