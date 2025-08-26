{ pkgs }:
{
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
  ];
  deps2 = with pkgs; [ lazygit ];
}
