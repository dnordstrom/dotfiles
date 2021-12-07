----
-- LANGUAGE SERVERS AND TOOLS
----

local null_ls = require("null-ls")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
local servers = {
	"bashls",
	"cssls",
	"gopls",
	"html",
	"jsonls",
	"null-ls",
	"rnix",
	"tsserver",
	"vimls",
	"yamlls",
}
local signs = {
	DiagnosticSignError = " ",
	DiagnosticSignWarn = "卑 ",
	DiagnosticSignHint = " ",
	DiagnosticSignInfo = " ",
}

--
-- Configuration
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

null_ls.config({
	sources = {
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.fixjson,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.nixfmt,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.shellharden,
		null_ls.builtins.formatting.stylelint,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.refactoring,
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.code_actions.statix,
		null_ls.builtins.hover.dictionary,
	},
})

--
-- Servers
--

local disable_formatting = function(client)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

local enable_formatting = function(client)
	if client.resolved_capabilities.document_formatting then
		vim.cmd([[
      augroup autoformat
      autocmd!
      autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup end
    ]])
	end
end

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
		on_attach = lsp == "null-ls" and enable_formatting or disable_formatting,
	})
end
