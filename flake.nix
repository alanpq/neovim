{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    neovim-nightly = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
    };
    flake-compat = {
      type = "github";
      owner = "edolstra";
      repo = "flake-compat";
      flake = false;
    };
    mnw = {
      type = "github";
      owner = "gerg-l";
      repo = "mnw";
    };
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim-nightly,
    mnw,
    systems,
    ...
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    inherit (nixpkgs) lib;
  in {
    #
    # Linter and formatter, run with "nix fmt"
    # You can use alejandra or nixpkgs-fmt instead of nixfmt if you wish
    #
    formatter = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.writeShellApplication {
          name = "format";
          runtimeInputs = builtins.attrValues {
            inherit
              (pkgs)
              nixfmt-rfc-style
              deadnix
              statix
              fd
              stylua
              ;
          };
          text = ''
            fd "$@" -t f -e nix -x statix fix -- '{}'
            fd "$@" -t f -e nix -X deadnix -e -- '{}' \; -X nixfmt '{}'
            fd "$@" -t f -e lua -X stylua --indent-type Spaces '{}'
          '';
        }
    );

    devShells = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShellNoCC {
          packages = [
            self.packages.${system}.default.devMode
            self.formatter.${system}
            pkgs.npins
          ];
        };
      }
    );

    packages = eachSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = self.packages.${system}.neovim;

        blink-cmp = pkgs.callPackage ./packages/blink-cmp/package.nix {};

        neovim = mnw.lib.wrap pkgs {
          inherit (neovim-nightly.packages.${system}) neovim;

          appName = "alanpq";

          extraLuaPackages = p: [p.jsregexp];

          providers = {
            nodeJs.enable = true;
            perl.enable = true;
          };

          # Source lua config
          initLua = ''
            require('alanpq')
          '';

          # Add lua config
          devExcludedPlugins = [
            ./alanpq
          ];
          # Impure path to lua config for devShell
          devPluginPaths = [
            "/home/alan/Projects/neovim/alanpq"
          ];

          desktopEntry = false;

          plugins =
            [
              #
              # Add plugins from nixpkgs here
              #
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars
              self.packages.${system}.blink-cmp
            ]
            ++ lib.mapAttrsToList (
              #
              # This generates plugins from npins sources
              #
              pname: pin: (
                pin
                // {
                  inherit pname;
                  version = builtins.substring 0 8 pin.revision;
                }
              )
            ) (pkgs.callPackages ./npins/sources.nix {});

          extraBinPath = builtins.attrValues {
            #
            # Runtime dependencies
            #
            inherit
              (pkgs)
              deadnix
              statix
              nil
              lua-language-server
              stylua
              #rustfmt
              ripgrep
              fzf
              fd
              chafa
              vscode-langservers-extracted
              ;
          };
        };
      }
    );
  };
}
