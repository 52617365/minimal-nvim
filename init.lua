vim.g.mapleader = ";"
vim.cmd("set clipboard=unnamedplus")
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
vim.opt.showmatch = false
vim.opt.number = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
  {'nvim-telescope/telescope.nvim', tag = '0.1.1', dependencies = { 'nvim-lua/plenary.nvim' }},
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"catppuccin/nvim", name = "catppuccin", priority = 1000},
  {"numToStr/Comment.nvim"},
}

require("lazy").setup(plugins)
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>s', ":source $HOME/.config/nvim/init.lua")
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})

vim.cmd("colorscheme catppuccin-macchiato")
require('Comment').setup()
