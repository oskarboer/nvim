-- Treesitter configuration without Lazy.nvim

-- Make sure you installed nvim-treesitter via Nix or your plugin manager

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
	return
end

configs.setup({
	ensure_installed = {
		-- add the languages you need:
		-- "lua",
		-- "vim",
		-- "vimdoc",
		-- "markdown",
		-- "markdown_inline",
		-- "bash",
		-- "c",
		-- "diff",
		-- "query",
		-- "ruby", -- example
	},

	auto_install = false,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "ruby" },
	},

	indent = {
		enable = true,
		disable = { "ruby" },
	},
})
