----
-- PLUGIN INSTALLATION
----

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path
  })
end

return require('packer').startup(function(use)
  --
  -- Package management and libraries
  --

  use "wbthomason/packer.nvim"
  use "nvim-lua/plenary.nvim"

  --
  -- Look and feel
  --

  use "famiu/feline.nvim"
  use "shaunsingh/nord.nvim"
  use {"rmehri01/onenord.nvim", branch = "main"}
  use "kyazdani42/nvim-web-devicons"
  use {"akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons"}
  use {"kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons"}


  --
  -- Instance and session tools
  --
  
  use "famiu/nvim-reload"
  use "famiu/bufdelete.nvim"

  --
  -- Movement and file navigation
  --

  use "vijaymarupudi/nvim-fzf"
  use "ibhagwan/fzf-lua"
  use "ggandor/lightspeed.nvim"
  use "folke/which-key.nvim"
  use "vifm/vifm.vim"
  use "christoomey/vim-tmux-navigator"

  --
  -- LSP, completion, snippets, and language
  --

  use "neovim/nvim-lspconfig"
  use "jose-elias-alvarez/null-ls.nvim"
  use "jose-elias-alvarez/nvim-lsp-ts-utils"
  use "onsails/lspkind-nvim"
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"
  use "saadparwaiz1/cmp_luasnip"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-calc"
  use "hrsh7th/cmp-emoji"
  use "hrsh7th/nvim-cmp"
  use "ujihisa/neco-look"
  use "f3fora/cmp-spell"

  use "LnL7/vim-nix"

  use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
  use {"nvim-treesitter/nvim-treesitter-textobjects"}
  use {"numToStr/Comment.nvim"}
  use "JoosepAlviste/nvim-ts-context-commentstring"

  --
  -- Tools and utilities
  --

  use "blackCauldron7/surround.nvim"
  use "tpope/vim-repeat"
  use "tpope/vim-fugitive"
  use "tpope/vim-markdown"
  use "windwp/nvim-autopairs"
  use "norcalli/nvim-colorizer.lua"
  use "ellisonleao/glow.nvim"

  use {"filipdutescu/renamer.nvim", branch = "master", requires = "nvim-lua/plenary.nvim"}
  use {"folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons"}
  use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}
  use {"lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim", tag = "release"}

  --
  -- Update and compile
  --

  if packer_bootstrap then
    require("packer").sync()
  end
end)

