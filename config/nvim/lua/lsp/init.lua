----
-- LANGUAGE SERVERS AND TOOLS
----

local null_ls = require("null-ls")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_clear_autocmds = vim.api.nvim_clear_autocmds
local nvim_buf_get_option = vim.api.nvim_buf_get_option
local capabilities = vim.lsp.protocol.make_client_capabilities()

--- LSP servers to autoload and call `setup()` on.
local autoload = {
	"cssls",
	"html",
	"jsonls",
	"rnix",
	"tsserver",
	"vimls",
	"yamlls",
}

--- Icons displayed in signs column.
local signs = {
	DiagnosticSignError = " ",
	DiagnosticSignWarn = " ",
	DiagnosticSignHint = " ",
	DiagnosticSignInfo = " ",
}

--- Disables formatting for given client.
--
-- @param client LSP client.
local disable_formatting = function(client)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
end

--- Enables formatting for given client and buffer number.
--
-- @param client LSP client.
-- @param bufnr  Buffer number.
local enable_formatting = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		local augroup_autoformat = nvim_create_augroup("autoformat", { clear = true })

		nvim_create_autocmd("BufWritePre", {
			group = augroup_autoformat,
			bufnr = bufnr,
			pattern = "*",
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end
end

----
-- UI
----

--
-- Diagnostics
--

vim.diagnostic.config({
	-- Show floating window
	float = {
		focus = false, -- Don't focus window (then we need to step out of it before moving)
		scope = "cursor", -- Show when cursor is on item, not whole line (`scope = "line"`)
		border = false, -- No border, obviously
	},

	-- Show icons in sign column
	signs = true,

	-- Underline errors
	underline = true,

	-- Update diagnostics while typing
	update_in_insert = true,

	-- Disable virtual text and sorting by severity
	virtual_text = false,
	severity_sort = false,
})

--
-- Signs
--

for hl, icon in pairs(signs) do
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

--
-- Completion
--

-- Use `nvim-cmp` for LSP completion via `cmp_nvim_lsp`
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- Enable snippet support using `luasnip` (configured in `nvim-cmp` setup)
capabilities.textDocument.completion.completionItem.snippetSupport = true

----
-- SERVERS
----

--`null-ls`
--
-- Does all formatting and is used when possible for out-of-the-box diagnostics, code actions, etc.
-- Makes it simple to set up more LSP sources without implementing an LSP server.
--
-- If server has `null-ls` source then we use that, otherwise `mason-lspconfig`, and if Mason
-- doesn't support it then we add it to `autoload` above to load and configure it manually. Rarely
-- happens since it's usually either in `null-ls` or `mason-lspconfig`.
--
-- NOTE: These need to be installed by Mason if possible, otherwise manually (OS package manager).
null_ls.setup({
	-- Sources to enable
	sources = {
		null_ls.builtins.completion.luasnip, -- Plugin
		null_ls.builtins.formatting.eslint_d, -- OS package
		null_ls.builtins.formatting.stylua, -- OS package
		null_ls.builtins.formatting.fixjson, -- OS package
		null_ls.builtins.formatting.gofumpt, -- OS package
		null_ls.builtins.formatting.nixfmt, -- OS package
		null_ls.builtins.formatting.shfmt.with({ -- OS package
			-- Fix massive(ly ugly) indenting in shell scripts
			extra_args = function(params)
				return {
					"-i",
					nvim_buf_get_option(params.bufnr, "shiftwidth"),
				}
			end,
		}),
		null_ls.builtins.formatting.stylelint, -- Mason
		null_ls.builtins.diagnostics.actionlint, -- OS package
		null_ls.builtins.diagnostics.alex, -- OS package
		null_ls.builtins.diagnostics.codespell, -- OS package
		null_ls.builtins.diagnostics.eslint_d, -- OS package
		null_ls.builtins.diagnostics.write_good, -- OS package
		null_ls.builtins.diagnostics.shellcheck, -- OS package
		null_ls.builtins.diagnostics.vale, -- OS package
		null_ls.builtins.code_actions.eslint_d, -- OS package
		null_ls.builtins.code_actions.gitsigns, -- Plugin
		null_ls.builtins.code_actions.proselint, -- OS package
		null_ls.builtins.code_actions.refactoring, -- OS package
		null_ls.builtins.code_actions.shellcheck, -- OS package
		null_ls.builtins.code_actions.statix, -- OS package
		null_ls.builtins.hover.dictionary, -- OS package
	},

	-- Enable formatting for `null-ls` only
	on_attach = function(client)
		enable_formatting(client)
	end,
})

-- Other
--
-- Sets up all the `autoload` servers, i.e. those that aren't set up by Mason or `null-ls`.

for _, lsp in ipairs(autoload) do
	lspconfig[lsp].setup({
		-- Use completion and snippet capabilities
		capabilities = capabilities,

		-- Set special flags
		flags = {
			-- Wait 5 seconds before sending `didChange` to solve slow LSP
			debounce_text_changes = 5000,
		},

		-- Disable formatting when attaching to buffer since it's handled by `null-ls`
		on_attach = function(client)
			disable_formatting(client)
		end,
	})
end
