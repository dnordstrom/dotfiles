----
-- MASON
----

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"awk_ls",
		"bashls",
		"cmake",
		"cssls",
		"cssmodules_ls",
		"diagnosticls",
		"dockerls",
		"eslint",
		"gopls",
		"graphql",
		"html",
		"jdtls",
		"jsonls",
		"lemminx",
		"marksman",
		"prosemd_lsp",
		"pylsp",
		"pyright",
		"quick_lint_js",
		"remark_ls",
		"rnix",
		"rust_analyzer",
		"stylelint_lsp",
		"sumneko_lua",
		"terraformls",
		"tsserver",
		"vimls",
		"yamlls",
		"zls",
	},
})
