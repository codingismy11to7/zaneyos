# Lazygit is a simple terminal UI for git commands.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  muted = "#${config.lib.stylix.colors.base03}";
in {
  programs.lazygit = {
    enable = true;
    package = pkgs.unstable.lazygit;
    settings = lib.mkForce {
      disableStartupPopups = true;
      notARepository = "skip";
      promptToReturnFromSubprocess = false;
      update.method = "never";
      git = {
        commit.signOff = false;
        parseEmoji = true;
        ignoreWhitespaceInDiffView = true;
        log = {
          showGraph = "when-maximised";
        };
        pagers = [
          {
            colorArg = "always";
            page = "delta --dark --paging=never";
          }
        ];
      };
      gui = {
        theme = {
          activeBorderColor = [
            accent
            "bold"
          ];
          inactiveBorderColor = [ muted ];
        };
        # showListFooter = false;
        showRandomTip = false;
        # showCommandLog = false;
        # showBottomLine = false;
        nerdFontsVersion = "3";
        spinner = {
          rate = 250;
          frames = [
            "🕛 "
            "🕐 "
            "🕑 "
            "🕒 "
            "🕓 "
            "🕔 "
            "🕕 "
            "🕖 "
            "🕗 "
            "🕘 "
            "🕙 "
            "🕚 "
          ];
        };
      };
    };
  };
}
