----
-- LANGUAGE SERVERS AND TOOLS
----

local nvim_create_augroup = vim.api.nvim_create_augroup
local nvim_create_autocmd = vim.api.nvim_create_autocmd
local nvim_clear_autocmds = vim.api.nvim_clear_autocmds
local nvim_buf_get_option = vim.api.nvim_buf_get_option
local capabilities = vim.lsp.protocol.make_client_capabilities()
local null_ls = require("null-ls")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local autoload = {
	"cssls",
	"html",
	"jsonls",
	"rnix",
	"tsserver",
	"vimls",
	"yamlls",
}
local signs = {
	DiagnosticSignError = " ",
	DiagnosticSignWarn = " ",
	DiagnosticSignHint = " ",
	DiagnosticSignInfo = " ",
}

local disable_formatting = function(client)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false
end

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

--
-- CONFIGURATION
--

-- Use floating window, icons, and underline

vim.diagnostic.config({
	float = { focus = false, scope = "cursor", border = false },
	signs = true,
	underline = true,
	virtual_text = false,
	severity_sort = false,
	update_in_insert = false,
})

for hl, icon in pairs(signs) do
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- nvim-cmp for completion and enable snippet suporrt

capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- null-ls for formatting

null_ls.setup({
	sources = {
		null_ls.builtins.completion.luasnip,
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.nixfmt,
		null_ls.builtins.formatting.shfmt.with({
			extra_args = function(params)
				return {
					"-i",
					nvim_buf_get_option(params.bufnr, "shiftwidth"),
				}
			end,
		}),
		null_ls.builtins.formatting.stylelint,
		null_ls.builtins.diagnostics.actionlint,
		null_ls.builtins.diagnostics.alex,
		null_ls.builtins.diagnostics.codespell,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.proselint,
		null_ls.builtins.code_actions.refactoring,
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.code_actions.statix,
		null_ls.builtins.hover.dictionary,
	},
	on_attach = function(client)
		enable_formatting(client)
	end,
})

--
-- SERVERS
--

for _, lsp in ipairs(autoload) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 5000, -- Wait 5 seconds before sending didChange (may solve slow LSP)
		},
		on_attach = function(client)
			disable_formatting(client)
		end,
	})
end
