# Credits
[primamateria](https://primamateria.github.io/blog/neovim-nix/#add-runtime-dependency) article (didn't follow it to the end yet) plus my own fixes and LLM help, figuring out nix is challenging.

# How it works

First `flake.nix` defines the input from nigtly neovim and then defines a few overlays to overlay packages/myNeovim.nix.

Then `myNeovim.nix` defines most of the stuff like where the config is, what plugins and other packages to include.

`plugins.nix` lists nvim specific plugins

while `runtimeDeps.nix` list general packages like LSPs, linters, formatters 
