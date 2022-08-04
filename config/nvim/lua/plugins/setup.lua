----
-- PLUGINS SETUP
----

local fn = vim.fn
local path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local command = "git clone --depth 1 https://github.com/wbthomason/packer.nvim"
local installed = fn.empty(fn.glob(path)) == 0
local bootstrapped = false

if not installed then
	bootstrapped = fn.system({ string.split(command, " "), path })
end

return require("packer").startup(function(use)
	local plenary = "nvim-lua/plenary.nvim"
	local devicons = "kyazdani42/nvim-web-devicons"

	--
	-- NEOVIM
	--

	-- Helper for plugins
	use({ plenary })

	-- Plugin manager
	use({ "wbthomason/packer.nvim" })

	-- Reloads configuration (`:Restart` triggers `VimEnter` while `:Reload` doesn't)
	use({ "famiu/nvim-reload" })

	--Integrates `fzf` and Neovim (UI in separate plugin)
	use({ "vijaymarupudi/nvim-fzf" })

	--
	-- UI
	--

	-- Icons
	use({ devicons }) -- Icons

	-- Colorschemes
	use({ "catppuccin/nvim", as = "catppuccin" })

	-- Status lines
	use({ "famiu/feline.nvim", branch = "master" })

	-- Buffer line (`methline` didn't exist so this will have to do)
	use({ "noib3/cokeline.nvim", requires = devicons })

	-- LSP diagnostics window
	use({ "folke/trouble.nvim", requires = devicons })

	--
	-- FILES AND BUFFERS
	--

	-- :Bdelete and :Bwipeout commands
	use({ "famiu/bufdelete.nvim" })

	-- UI for `nvim-fzf`
	use({ "ibhagwan/fzf-lua" })

	-- Vifm inside Vim
	use({ "vifm/vifm.vim" })

	--
	-- Movement
	--

	-- UI for key map hints
	use({ "folke/which-key.nvim" })

	-- Seamless navigation between Vim and Kitty windows
	use({
		"knubie/vim-kitty-navigator",
		branch = "master",
		run = "sed -i 's/neighboring_window\\.py/\\.\\/kittens\\/neighboring_window\\.py/g' ./plugin/kitty_navigator.vim",
	})

	--
	-- LANGUAGE AND SYNTAX
	--

	--
	-- Language server configuration
	--

	-- Provides sources for out-of-the-box diagnostics, code actions, etc. and handles all formatting.
	use({ "jose-elias-alvarez/null-ls.nvim" })
	use({ "onsails/lspkind-nvim" })
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})

	-- Language

	use({ "LnL7/vim-nix" })
	use({ "fladson/vim-kitty" })
	use({ "tpope/vim-markdown" })
	use({ "tridactyl/vim-tridactyl" })
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })
	use({ "elkowar/yuck.vim" })

	-- Completion

	use({ "f3fora/cmp-spell" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-calc" })
	use({ "hrsh7th/cmp-cmdline" })
	use({ "hrsh7th/cmp-emoji" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/nvim-cmp" })
	use({ "lukas-reineke/cmp-rg" })
	use({ "ray-x/cmp-treesitter" })
	use({ "saadparwaiz1/cmp_luasnip" })
	use({ "ujihisa/neco-look" })

	-- Snippets

	use({ "L3MON4D3/LuaSnip", branch = "master" })
	use({ "rafamadriz/friendly-snippets" })

	-- Refactoring

	use({ "filipdutescu/renamer.nvim", branch = "master", requires = plenary })
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = { { plenary }, { "nvim-treesitter/nvim-treesitter" } },
	})

	-- Comments

	use({ "numToStr/Comment.nvim" }) -- Commenter

	-- JSX/TSX markup comment support
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	-- Documentation comment generator
	use({
		"danymat/neogen",
		config = function()
			require("neogen").setup({ snippet_engine = "luasnip" })
		end,
	})

	--
	-- Utilities
	--

	-- Text

	use({ "windwp/nvim-autopairs" })
	use({ "echasnovski/mini.nvim", branch = "main" }) -- For surround
	use({ "tpope/vim-repeat" })

	-- Visuals

	use({
		"lukas-reineke/headlines.nvim",
		config = function()
			require("headlines").setup()
		end,
	})
	use({ "norcalli/nvim-colorizer.lua" })
	use({ "folke/todo-comments.nvim", requires = plenary })
	use({ "lewis6991/gitsigns.nvim", requires = plenary, tag = "release" })
	use({ "lukas-reineke/indent-blankline.nvim" })

	-- VCS

	use({ "tpope/vim-fugitive" })

	-- Previewers

	use({ "ellisonleao/glow.nvim" })

	--
	-- Update and compile
	--

	if bootstrapped then
		require("packer").sync()
	end
end)
