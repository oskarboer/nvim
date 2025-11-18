{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  plugins = import ../plugins.nix { inherit pkgs; };
  runtimeDeps = import ../runtimeDeps.nix { inherit pkgs; };
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = runtimeDeps.deps1;
  };
  neovimRuntimeDependencies2 = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies2";
    paths = runtimeDeps.deps2;
  };
  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim {
    configure = {
      inherit customRC;
      packages.all.start = plugins;
    };
  };
in
pkgs.writeShellApplication {
  name = "nvim";
  # nodePackages seem to have issue when used with pkgs.symlinkJoin funciton
  # binary doesn't get discovered. So instead I put it here. For more info
  # google pkgs.symlinkJoin and nodePackages doesn't work.

  runtimeInputs = [
    neovimRuntimeDependencies2
    neovimRuntimeDependencies
    pkgs.nodePackages.cspell
    pkgs.nodePackages.typescript-language-server
  ];
  text = ''
    ${myNeovimUnwrapped}/bin/nvim "$@"
  '';
}
