{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.stylix) colors;

  theme = {
    palette = "Custom";
    colours = {
      base_00 = "#${colors.base00}";
      base_01 = "#${colors.base01}";
      base_02 = "#${colors.base02}";
      base_03 = "#${colors.base03}";
      base_04 = "#${colors.base04}";
      base_05 = "#${colors.base05}";
      base_06 = "#${colors.base06}";
      base_07 = "#${colors.base07}";
      base_08 = "#${colors.base08}";
      base_09 = "#${colors.base09}";
      base_0a = "#${colors.base0A}";
      base_0b = "#${colors.base0B}";
      base_0c = "#${colors.base0C}";
      base_0d = "#${colors.base0D}";
      base_0e = "#${colors.base0E}";
      base_0f = "#${colors.base0F}";
    };
  };
in {
  # TODO: need to not hardcode
  home.activation.patchKomorebi = lib.hm.dag.entryAfter ["writeBoundary"] ''
    KOMOREBI_FILE="/mnt/c/Users/steve/komorebi.json"

    if [ -f "$KOMOREBI_FILE" ]; then
      verboseEcho "Patching komorebi JSON theme at $KOMOREBI_FILE..."
      THEME_JSON='${builtins.toJSON theme}'

      run ${pkgs.jq}/bin/jq --argjson theme "$THEME_JSON" '.theme = $theme' "$KOMOREBI_FILE" > "$KOMOREBI_FILE.tmp"
      run mv "$KOMOREBI_FILE.tmp" "$KOMOREBI_FILE"
    else
      verboseEcho "Error: Komorebi file not found at $KOMOREBI_FILE"
      # TODO: why print error and exit success...
      #  i mean i know why but fix later
      exit 0
    fi
  '';
}
