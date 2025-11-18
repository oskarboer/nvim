-- cspell.nvim + none-ls configuration
-- Place this in your init.lua or in a separate config file

-- Make sure both plugins are in your runtimepath
-- If using vim-plug:
--   Plug 'nvimtools/none-ls.nvim'
--   Plug 'davidmh/cspell.nvim'
-- If using packer:
--   use 'nvimtools/none-ls.nvim'
--   use 'davidmh/cspell.nvim'

local cspell = require("cspell")
local null_ls = require("null-ls")

-- Setup none-ls (null-ls)
null_ls.setup({
	sources = {
		-- Add cspell diagnostics with HINT severity
		cspell.diagnostics.with({
			diagnostics_postprocess = function(diagnostic)
				diagnostic.severity = vim.diagnostic.severity.HINT
			end,
		}),
		-- Add cspell code actions (for adding words to dictionary, etc.)
		cspell.code_actions,
	},
})

-- Optional: Set up keybindings for code actions
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions (including cspell)" })

-- Optional: Configure which filetypes to enable
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "gitcommit", "lua", "python", "javascript", "typescript" },
	callback = function()
		vim.diagnostic.enable(true)
	end,
})
