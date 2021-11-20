local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'shaunsingh/nord.nvim'
  use 'rmehri01/onenord.nvim'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'tpope/vim-markdown'
  use 'christoomey/vim-tmux-navigator'
  use 'norcalli/nvim-colorizer.lua'
  use 'ellisonleao/glow.nvim'
  use 'b3nj5m1n/kommentary'
  use 'famiu/feline.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'neovim/nvim-lspconfig'
  use 'vijaymarupudi/nvim-fzf'
  use 'ibhagwan/fzf-lua'
  use 'folke/which-key.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'windwp/nvim-autopairs'
  use 'LnL7/vim-nix'

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/vim-vsnip'

  use {
    'filipdutescu/renamer.nvim',
    branch = 'master',
    requires = 'nvim-lua/plenary.nvim'
  }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons"
  }

  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
