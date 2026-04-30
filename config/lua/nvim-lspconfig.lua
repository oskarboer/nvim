-- nvim-lspconfig setup for Neovim 0.12+
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Telescope-based navigation
		local tb = require("telescope.builtin")
		map("gd", tb.lsp_definitions, "[G]oto [D]efinition")
		map("gr", tb.lsp_references, "[G]oto [R]eferences")
		map("gI", tb.lsp_implementations, "[G]oto [I]mplementation")
		map("<leader>D", tb.lsp_type_definitions, "Type [D]efinition")
		map("<leader>ds", tb.lsp_document_symbols, "[D]ocument [S]ymbols")
		map("<leader>ws", tb.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		-- LSP core features
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		-- Highlight references if supported
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight") then
			local highlight_group = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_group,
				callback = vim.lsp.buf.clear_references,
			})
		end

		-- Inlay hints toggle (new API in 0.12+)
		if client and client:supports_method("textDocument/inlayHint") then
			map("<leader>th", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Diagnostics configuration
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
	},
})

-- local capabilities = vim.tbl_deep_extend(
-- 	"force",
-- 	{},
-- 	vim.lsp.protocol.make_client_capabilities()
-- 	-- require("blink.cmp").get_lsp_capabilities()
-- )

vim.lsp.config("lua_lsp", { capabilities = capabilities })
vim.lsp.config("rust_analyzer", { capabilities = capabilities })
vim.lsp.config("gopls", { capabilities = capabilities })

vim.lsp.enable("lua_lsp")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("gopls")
