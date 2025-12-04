{ pkgs, ... }:
{
  home.packages = [ pkgs.fish ];

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting

      fzf_configure_bindings --git_status= --git_log=

      bind ctrl-alt-l _lazygit_log
      bind ctrl-alt-s _lazygit_status

      fastfetch
    '';

    functions = {
      _in_zellij = builtins.readFile ./functions/_in_zellij.fish;
      _lazygit_status = builtins.readFile ./functions/_lazygit_status.fish;
      _lazygit_log = builtins.readFile ./functions/_lazygit_log.fish;
      _run_cmd_in_zellij_popup = builtins.readFile ./functions/_run_cmd_in_zellij_popup.fish;
    };

    shellAliases = {
      cat = "bat";
      du = "dust";
      lg = "lazygit";
      ls = "eza";
      vim = "nvim";

      gembot = "npx -y @google/gemini-cli@latest";
    };

    shellAbbrs = {
      reb = "nh os switch";
    };

    plugins = with pkgs.fishPlugins; [
      {
        inherit (bass) src;
        name = "bass";
      }
      {
        inherit (fzf-fish) src;
        name = "fzf.fish";
      }
      {
        inherit (tide) src;
        name = "tide";
      }
    ];
  };
}
