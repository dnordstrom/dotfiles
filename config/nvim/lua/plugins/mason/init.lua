----
-- MASON
----

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"cmake",
		"cssls",
		"cssmodules_ls",
		"diagnosticls",
		"dockerls",
		"eslint",
		"gopls",
		"grammarly",
		"graphql",
		"html",
		"jsonls",
		"marksman",
		"prosemd_ls",
		"pylsp",
		"pyright",
		"quick_lint_js",
		"remark_ls",
		"rnix",
		"rust_analyzer",
		"stylelint_lsp",
		"sumneko_lua",
		"tsserver",
		"vale",
		"vimls",
		"yamlls",
		"zls",
	},
})
