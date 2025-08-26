vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.mouse = "a"

vim.opt.undofile = true

vim.opt.tabstop = 4 -- Number of spaces a tab represents
vim.opt.shiftwidth = 4 -- Number of spaces for each indentation
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Automatically indent new lines
vim.opt.wrap = false -- Disable line wrapgPping
vim.opt.relativenumber = true -- relative lines numbering

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Remove carriage returns from the current buffer
-- Usage: :StripCR
vim.api.nvim_create_user_command("StripCR", function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd([[:%s/\r//g]])
	vim.api.nvim_win_set_cursor(0, cursor_pos)
	print("Stripped carriage returns from buffer")
end, {
	desc = "Remove all carriage returns (\\r) from the current buffer",
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Easy moving around split windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- copy and paste from buffer
vim.keymap.set({ "n", "x" }, "gy", '"+y')
vim.keymap.set({ "n", "x" }, "gp", '"+p')
vim.keymap.set({ "n", "x" }, "gP", '"+P')

vim.keymap.set({ "i", "v" }, "kj", "<Esc>")

-- select all
vim.keymap.set("n", "<leader>a", ":keepjumps normal! ggVG<cr>")

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show full [E]rror message" })

-- 0.11 LSP config
--
-- python
vim.lsp.enable("basedpyright")
vim.lsp.enable("pyright")

vim.lsp.enable("pylsp")
vim.lsp.config["pylsp"] = {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = { "W391" },
					maxLineLength = 120,
				},
				ropeautoimport = {
					enabled = true,
				},
			},
		},
	},
}

vim.lsp.enable("rust_analyzer")
vim.lsp.enable("nil_ls")

vim.lsp.enable("lua_ls")
vim.lsp.config["lua_ls"] = {
	-- cmd = {...},
	-- filetypes = { ...},
	-- capabilities = {},
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			-- diagnostics = { disable = { 'missing-fields' } },
		},
	},
}
