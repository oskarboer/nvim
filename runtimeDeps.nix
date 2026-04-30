{ pkgs }:
{
  # NOTE: add nodePackages directly to the packages/myNeovim.nix file, into runtimeInpunt
  # symlinkJoin doesn't work well with it.

  deps1 = with pkgs; [
    nodePackages.typescript-language-server
    gcc # needed for nvim-treesitter
    python312Packages.python-lsp-server
    python312Packages.pylsp-rope
    pyright
    basedpyright
    stylua
    lua-language-server
    rust-analyzer
    nil
    python313Packages.debugpy
    ruff
    ty
    nerd-fonts.jetbrains-mono
  ];
  # I don't know why there are two of those
  deps2 = with pkgs; [
    lazygit
    nodePackages.cspell
  ];
}
