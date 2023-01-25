----
-- PLUGINS SETUP
----

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	local devicons = "kyazdani42/nvim-web-devicons"
	local plenary = "nvim-lua/plenary.nvim"
	local treesitter = "nvim-treesitter/nvim-treesitter"

	--
	-- NEOVIM
	--

	-- Plugin manager (must come first)
	use({ "wbthomason/packer.nvim" })

	-- Helper for plugins
	use({ plenary })

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

	-- Seamless navigation between Vim and Kitty windows.
	--
	-- TODO: Go back to knubie's repo when PR is merged: https://github.com/knubie/vim-kitty-navigator/pull/33
	use({ "kintsugi/vim-kitty-navigator", branch = "master" })
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
	use({ "elkowar/yuck.vim" })
	use({ "fladson/vim-kitty" })
	use({ "tpope/vim-markdown" })
	use({ "tridactyl/vim-tridactyl" })
	use({
		treesitter,
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
	use({
		"folke/twilight.nvim",
		-- config = function() require("twilight").setup({}) end
	})
	use({ "nvim-treesitter/nvim-treesitter-textobjects" })

	-- Completion

	use({ "f3fora/cmp-spell" })
	use({ "hrsh7th/cmp-calc" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/nvim-cmp" })
	use({ "lukas-reineke/cmp-rg" })
	use({ "ray-x/cmp-treesitter" })
	use({ "saadparwaiz1/cmp_luasnip" })
	use({ "hrsh7th/cmp-buffer" })

	-- Snippets

	use({ "L3MON4D3/LuaSnip", branch = "master" })
	use({ "rafamadriz/friendly-snippets" })

	-- Refactoring

	use({ "filipdutescu/renamer.nvim", branch = "master", requires = plenary })
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = { { plenary }, { treesitter } },
	})

	-- Comments

	use({ "numToStr/Comment.nvim" }) -- Commenter

	-- Context aware commenting using tree-sitter
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
	use({ "lewis6991/gitsigns.nvim", requires = plenary, tag = "main" }) -- `main` for Nightly support
	use({ "lukas-reineke/indent-blankline.nvim" })

	-- VCS

	use({ "tpope/vim-fugitive" })

	-- Previewers

	use({ "ellisonleao/glow.nvim", ft = "markdown" })

	--
	-- Update and compile
	--

	if packer_bootstrap then
		require("packer").sync()
	end
end)
