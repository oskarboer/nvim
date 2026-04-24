-- ~/.config/nvim/lua/dap-config.lua
-- (require this from your init.lua with: require('dap-config'))

local dap = require("dap")
local dv = require("dap-view")
local dap_python = require("dap-python")

-- ─── 1. Python adapter + configurations (via nvim-dap-python) ─────────────────
-- Previously we configured the adapter and launch configurations manually.
-- nvim-dap-python replaces ALL of that with a single setup() call.
-- It registers the debugpy adapter and adds sensible default configurations
-- automatically (launch file, launch module, attach, django, etc.)
--
-- We pass it the python interpreter that has debugpy installed.
-- Since nix manages your environment, debugpy will be available on the
-- system python. If you ever use a venv, dap-python will detect and
-- prefer it automatically at launch time.
dap_python.setup(vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python")

-- Optional: set the test runner (default is already pytest, but being explicit
-- is good). Switch to 'unittest' if that's what you use.
dap_python.test_runner = "pytest"

-- ─── 3. Auto-open / auto-close dapui ─────────────────────────────────────────
-- Unchanged — these listeners are wired to dap session events, not the adapter.
dap.listeners.after.event_initialized["dapui_config"] = function()
	dv.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dv.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dv.close()
end

local dv_opts = {
	winbar = {
		controls = {
			enabled = true,
		},
	},
}

dv.setup(dv_opts)
-- ─── 4. Keymaps ───────────────────────────────────────────────────────────────
local map = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Session control
map("<leader>dc", dap.continue, "DAP: continue / start")
map("<leader>dq", dap.terminate, "DAP: terminate session")
map("<leader>dr", dap.restart, "DAP: restart session")

-- Stepping
map("<leader>dn", dap.step_over, "DAP: step over")
map("<leader>di", dap.step_into, "DAP: step into")
map("<leader>do", dap.step_out, "DAP: step out")

-- Breakpoints
map("<leader>db", dap.toggle_breakpoint, "DAP: toggle breakpoint")
map("<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, "DAP: conditional breakpoint")
map("<leader>dl", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, "DAP: log point")

-- UI
map("<leader>du", dv.toggle, "DAP: toggle UI")

-- map("<leader>de", dapui.eval, "DAP: evaluate expression")
map("<leader>dh", function()
	require("dap.ui.widgets").hover()
end, "DAP: hover value")

-- ─── 5. Test keymaps (new — powered by nvim-dap-python) ──────────────────────
-- These are the main reason to use nvim-dap-python.
-- dap-python introspects the AST of the current buffer to find the nearest
-- test class / test function and launches a focused debug session for it.
map("<leader>dtf", dap_python.test_method, "DAP: debug nearest test function")
map("<leader>dtc", dap_python.test_class, "DAP: debug nearest test class")

-- Visual mode: debug the selected code snippet in isolation.
vim.keymap.set(
	"v",
	"<leader>ds",
	dap_python.debug_selection,
	{ noremap = true, silent = true, desc = "DAP: debug selection" }
)

-- nice colors
--
vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texthl = "", linehl = "", numhl = "" })

vim.fn.sign_define("DapBreakpointCondition", {
	text = "🟡", -- or '' with Nerd Font
	texthl = "",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapLogPoint", {
	text = "🔵", -- or '' with Nerd Font
	texthl = "",
	linehl = "",
	numhl = "",
})

vim.fn.sign_define("DapStopped", {
	text = "➡️", -- or '' with Nerd Font
	texthl = "",
	linehl = "DapStoppedLine",
	numhl = "",
})

-- ─── Highlight groups ─────────────────────────────────────────────────────────
-- These are defined with vim.api.nvim_set_hl so they work with any colorscheme.
-- Put them inside a colorscheme autocmd if you want them to survive theme changes.

local hl = function(name, opts)
	vim.api.nvim_set_hl(0, name, opts)
end
hl("DapStoppedLine", { bg = "#1f3d1f" })

-- -- Breakpoint: red family
-- hl("DapBreakpoint", { fg = "#e06c75" })
-- hl("DapBreakpointLine", { bg = "#2d1f1f" })
-- hl("DapBreakpointNum", { fg = "#e06c75", bold = true })
--
-- Conditional breakpoint: orange
-- hl("DapBreakpointCondition", { fg = "#e5c07b" })

-- Log point: blue
-- hl("DapLogPoint", { fg = "#61afef" })

-- Rejected: muted / grey
-- hl("DapBreakpointRejected", { fg = "#5c6370", italic = true })

-- Current line: green family
-- hl("DapStopped", { fg = "#98c379" })
-- hl("DapStoppedNum", { fg = "#98c379", bold = true })

-- ─── Surviving colorscheme changes ────────────────────────────────────────────
-- If you switch themes at runtime the highlights above get wiped.
-- This autocmd re-applies them after any colorscheme is loaded.
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	pattern = "*",
-- 	callback = function()
-- 		hl("DapBreakpoint", { fg = "#e06c75" })
-- 		hl("DapBreakpointLine", { bg = "#2d1f1f" })
-- 		hl("DapBreakpointNum", { fg = "#e06c75", bold = true })
-- 		hl("DapBreakpointCondition", { fg = "#e5c07b" })
-- 		hl("DapLogPoint", { fg = "#61afef" })
-- 		hl("DapBreakpointRejected", { fg = "#5c6370", italic = true })
-- 		hl("DapStopped", { fg = "#98c379" })
-- 		hl("DapStoppedLine", { bg = "#1f2d1f" })
-- 		hl("DapStoppedNum", { fg = "#98c379", bold = true })
-- 	end,
-- })
