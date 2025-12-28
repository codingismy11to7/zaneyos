{ inputs, ... }:
let
  inherit (inputs) nixCats;
  inherit (nixCats) utils;
  nixpkgs = inputs.nixpkgs-unstable;
  luaPath = ./.;

  # the following extra_pkg_config contains any values
  # which you want to pass to the config set of nixpkgs
  # import nixpkgs { config = extra_pkg_config; inherit system; }
  # will not apply to module imports
  # as that will have your system values
  extra_pkg_config = {
    # allowUnfree = true;
  };

  dependencyOverlays = [
    # This overlay grabs all the inputs named in the format
    # `plugins-<pluginName>`
    # Once we add this overlay to our nixpkgs, we are able to
    # use `pkgs.neovimPlugins`, which is a set of our plugins.
    (utils.standardPluginOverlay inputs)
    # add any other flake overlays here.
  ];

  # see :help nixCats.flake.outputs.categories
  # and
  # :help nixCats.flake.outputs.categoryDefinitions.scheme
  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    }@packageDef:
    {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = with pkgs.unstable; {
        general = [
          universal-ctags
          ast-grep
          curl
          # NOTE:
          # lazygit
          # Apparently lazygit when launched via snacks cant create its own config file
          # but we can add one from nix!
          (pkgs.writeShellScriptBin "lazygit" ''
            exec ${lazygit}/bin/lazygit --use-config-file ${pkgs.writeText "lazygit_config.yml" ""} "$@"
          '')
          ripgrep
          fd
          imagemagick
          shfmt
          stdenv.cc
          lua-language-server
          marksman
          nil
          statix
          stylua
          taplo
          tree-sitter
          vscode-langservers-extracted
          vtsls
        ];
      };

      # NOTE: lazy doesnt care if these are in startupPlugins or optionalPlugins
      # also you dont have to download everything via nix if you dont want.
      # but you have the option, and that is demonstrated here.
      startupPlugins = with pkgs.unstable.vimPlugins; {
        general = [
          # LazyVim
          lazy-nvim
          LazyVim
          bufferline-nvim
          lazydev-nvim
          copilot-vim
          conform-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          grug-far-nvim
          noice-nvim
          lualine-nvim
          mini-files
          mini-hipatterns
          nui-nvim
          nvim-lint
          nvim-lspconfig
          nvim-treesitter-textobjects
          nvim-ts-autotag
          ts-comments-nvim
          blink-cmp
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          # telescope-fzf-native-nvim
          # telescope-nvim
          todo-comments-nvim
          tokyonight-nvim
          trouble-nvim
          vim-illuminate
          vim-startuptime
          which-key-nvim
          snacks-nvim
          zellij-nvim
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          # This is for if you only want some of the grammars
          # (nvim-treesitter.withPlugins (
          #   plugins: with plugins; [
          #     nix
          #     lua
          #   ]
          # ))

          # sometimes you have to fix some names
          # { plugin = catppuccin-nvim; name = "catppuccin"; }
          {
            plugin = mini-ai;
            name = "mini.ai";
          }
          {
            plugin = mini-icons;
            name = "mini.icons";
          }
          {
            plugin = mini-pairs;
            name = "mini.pairs";
          }
          # you could do this within the lazy spec instead if you wanted
          # and get the new names from `:NixCats pawsible` debug command
        ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
      # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
      # I just put them all in startupPlugins. I could have put them all in here instead.
      optionalPlugins = { };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          ''--set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = {
        test = [ (_: [ ]) ];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [ (_: [ ]) ];
      };
    };

  # And then build a package with specific categories from above here:
  # All categories you wish to include must be marked true,
  # but false may be omitted.
  # This entire set is also passed to nixCats for querying within the lua.

  # see :help nixCats.flake.outputs.packageDefinitions
  packageDefinitions = {
    # These are the names of your packages
    # you can include as many as you wish.
    nvim =
      {
        pkgs,
        name,
        mkPlugin,
        ...
      }:
      {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          # IMPORTANT:
          # your alias may not conflict with your other packages.
          # aliases = [ "vim" ];
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories = {
          general = true;
          test = false;
        };
        extra = { };
      };
    # an extra test package with normal lua reload for fast edits
    # nix doesnt provide the config in this package, allowing you free reins to edit it.
    # then you can swap back to the normal pure package when done.
    testnvim =
      {
        pkgs,
        mkPlugin,
        ...
      }:
      {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = false;
          unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/zaneyos/modules/home/editors/nixcats-lazyvim'";
        };
        categories = {
          general = true;
          test = false;
        };
        extra = { };
      };
  };

  defaultPackageName = "nvim";
in
{
  imports = [
    (utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    })
  ];

  nvim.enable = true;
}
