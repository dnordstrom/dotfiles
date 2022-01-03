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
	-- Neovim
	--

	use({ plenary })
	use({ "wbthomason/packer.nvim" })
	use({ "famiu/nvim-reload" })

	--
	-- UI
	--

	-- Icons

	use({ devicons })

	-- Lines

	use({ "famiu/feline.nvim", branch = "develop" })
	use({ "noib3/cokeline.nvim", requires = devicons })

	-- Colorschemes

	use({ "shaunsingh/nord.nvim" })
	use({ "rmehri01/onenord.nvim", branch = "main" })
	use({ "catppuccin/nvim", as = "catppuccin" })

	-- Files and buffers

	use({ "famiu/bufdelete.nvim" })
	use({ "kyazdani42/nvim-tree.lua", requires = devicons })
	use({ "vijaymarupudi/nvim-fzf" })
	use({ "ibhagwan/fzf-lua" })
	use({ "vifm/vifm.vim" })

	--
	-- Movement
	--

	use({ "folke/which-key.nvim" })
	use({ "ggandor/lightspeed.nvim" })
	use({ "numToStr/Navigator.nvim" }) -- tmux
	use({ "knubie/vim-kitty-navigator" }) -- kitty

	--
	-- Language and syntax
	--

	-- LSP

	use({ "neovim/nvim-lspconfig" })
	use({ "jose-elias-alvarez/null-ls.nvim" })
	use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })
	use({ "folke/trouble.nvim", requires = devicons })
	use({ "onsails/lspkind-nvim" })

	-- Language

	use({ "LnL7/vim-nix" })
	use({ "fladson/vim-kitty" })
	use({ "tpope/vim-markdown" })
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })

	-- Completion

	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-cmdline" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-calc" })
	use({ "hrsh7th/cmp-emoji" })
	use({ "hrsh7th/nvim-cmp" })
	use({ "saadparwaiz1/cmp_luasnip" })
	use({ "ray-x/cmp-treesitter" })
	use({ "ujihisa/neco-look" })
	use({ "f3fora/cmp-spell" })

	-- Snippets

	use({ "L3MON4D3/LuaSnip" })
	use({ "rafamadriz/friendly-snippets" })

	-- Refactoring

	use({ "filipdutescu/renamer.nvim", branch = "master", requires = plenary })
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = { { plenary }, { "nvim-treesitter/nvim-treesitter" } },
	})

	-- Comments

	use({ "numToStr/Comment.nvim" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	--
	-- Utilities
	--

	-- Text

	use({ "windwp/nvim-autopairs" })
	use({ "blackCauldron7/surround.nvim" })
	use({ "tpope/vim-repeat" })

	-- Visuals

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
