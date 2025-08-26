require("neo-tree").setup({
	filesystem = {
		window = {
			mappings = {
				["\\"] = "close_window",
			},
		},
	},
})

vim.keymap.set("n", "\\", "<Cmd>Neotree reveal<CR>", { desc = "Reveal Neo-tree", silent = true })
