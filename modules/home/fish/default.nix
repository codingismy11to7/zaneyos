{
  lib,
  pkgs,
  zaneyos,
  ...
}: let
  join = lib.concatStringsSep " ";

  fastfetch = "${pkgs.unstable.fastfetch}/bin/fastfetch";
  fastfetchCmd =
    if (zaneyos.fastfetchLogo == null)
    then fastfetch
    else "${fastfetch} --logo-height 23 --chafa ${zaneyos.fastfetchLogo}";

  tte = pkgs.unstable.terminaltexteffects;
in {
  home.packages = [pkgs.fish];

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting

      fzf_configure_bindings --git_status= --git_log=

      bind ctrl-alt-l _lazygit_log
      bind ctrl-alt-s _lazygit_status

      set -x DOCKER_HOST /run/user/1000/podman/podman.sock

      ${fastfetchCmd}

      if not ${pkgs.openssh}/bin/ssh-add -l > /dev/null 2>&1
          echo "SSH identity not found. Please run 'ssh-add' to add your key." | ${tte}/bin/tte --frame-rate 300 wipe
      end
    '';

    functions = {
      _in_zellij = builtins.readFile ./functions/_in_zellij.fish;
      _lazygit_status = builtins.readFile ./functions/_lazygit_status.fish;
      _lazygit_log = builtins.readFile ./functions/_lazygit_log.fish;
      _run_cmd_in_zellij_popup = builtins.readFile ./functions/_run_cmd_in_zellij_popup.fish;
    };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      du = "${pkgs.unstable.dust}/bin/dust";
      lg = "${pkgs.unstable.lazygit}/bin/lazygit";
      vim = "nvim";

      gembot = "npx -y @google/gemini-cli@latest";
    };

    shellAbbrs = {
    };

    plugins = with pkgs.fishPlugins; [
      {
        name = "bass";
        inherit (bass) src;
      }
      {
        name = "fzf.fish";
        inherit (fzf-fish) src;
      }
      {
        name = "tide";
        inherit (tide) src;
      }
    ];
  };

  home.activation = {
    configureFishTide = lib.hm.dag.entryAfter ["linkGeneration"] (
      let
        tideArgs = [
          "tide configure"
          "--auto"
          "--style=Rainbow"
          # TODO: revisit when/if stylix adds true color support
          "--prompt_colors='16 colors'"
          "--show_time='12-hour format'"
          "--rainbow_prompt_separators=Slanted"
          "--powerline_prompt_heads=Sharp"
          "--powerline_prompt_tails=Flat"
          "--powerline_prompt_style='Two lines, character and frame'"
          "--prompt_connection=Dotted"
          "--powerline_right_prompt_frame=No"
          "--prompt_connection_andor_frame_color=Dark"
          "--prompt_spacing=Sparse"
          "--icons='Many icons'"
          "--transient=Yes"
        ];
      in ''
        verboseEcho "Configuring Tide for Fish shell..."

        fish_function_path=${pkgs.fishPlugins.tide}/share/fish/vendor_functions.d/ \
          ${pkgs.fish}/bin/fish --interactive --command "${join tideArgs}"
      ''
    );
  };
}
