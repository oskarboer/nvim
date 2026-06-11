{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    telescope-recent-files-src = {
      url = "github:smartpde/telescope-recent-files";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      neovim,
      telescope-recent-files-src,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      overlayFlakeInputs = prev: final: {
        neovim = neovim.packages.${final.system}.neovim;

        vimPlugins = final.vimPlugins // {
          telescope-recent-files = import ./packages/vimPlugins/telescopeRecentFiles.nix {
            src = telescope-recent-files-src;
            pkgs = prev;
          };
        };
      };

      overlayMyNeovim = prev: final: {
        myNeovim = import ./packages/myNeovim.nix {
          pkgs = final;
        };
      };
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            overlayFlakeInputs
            overlayMyNeovim
          ];
        };
    in
    {
      packages = forAllSystems (system: {
        default = (mkPkgs system).myNeovim;
      });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${(mkPkgs system).myNeovim}/bin/nvim";
        };
      });
    };
}
