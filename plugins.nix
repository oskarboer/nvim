{ pkgs }:
with pkgs.vimPlugins;
[
  lazy-nvim
  lualine-nvim
  nvim-treesitter.withAllGrammars

  nvim-lspconfig
  luvit-meta
  lazydev-nvim

  blink-cmp
  friendly-snippets

  conform-nvim

  telescope-nvim
  telescope-ui-select-nvim

  telescope-fzf-native-nvim

  neo-tree-nvim

  luasnip

  mini-nvim

  fidget-nvim

  nvim-web-devicons
  nui-nvim

  todo-comments-nvim
  plenary-nvim

  nvim-ts-context-commentstring
  which-key-nvim
  tokyonight-nvim
  vim-sleuth

  gitsigns-nvim

  nvim-autopairs
  indent-blankline-nvim

  cspell-nvim
  none-ls-nvim

  nvim-dap
  nvim-dap-view
  nvim-nio
  nvim-dap-python
]
