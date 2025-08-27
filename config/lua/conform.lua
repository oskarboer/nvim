require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff" },
		rust = { "rustfmt", lsp_format = "fallback" },
	},
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		return {
			timeout_ms = 500,
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		}
	end,
})

vim.keymap.set(
	"",
	"<leader>f",
	"require('conform').format({ async = true, lsp_fallback = true})",
	{ desc = "[F]ormat buffer" }
)
