local vim = vim

vim.g.mapleader = ";"
vim.cmd("set clipboard=unnamedplus")
vim.cmd("set nowrap")
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- vim.opt.showmatch = false
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

local M = {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
	},
}

M.config = function()
	local cmp = require("cmp")
	vim.opt.completeopt = { "menu", "menuone", "noselect" }

	cmp.setup({
		mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "buffer" },
		}),
	})
end

plugins = {
  {'nvim-telescope/telescope.nvim', tag = '0.1.1', dependencies = { 'nvim-lua/plenary.nvim' }},
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"Shatur/neovim-ayu"},
  {"numToStr/Comment.nvim"},
  {"neovim/nvim-lspconfig"},
  {'phaazon/hop.nvim'},
  {'tpope/vim-fugitive'},
  M,
}

require("lazy").setup(plugins)
require('telescope').load_extension('fzf')

vim.wo.signcolumn = "yes" -- Avoids the weird little movement with rust lsp

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>s', ":vsplit<CR>")
vim.keymap.set('n', '<leader><leader>', "<C-W>w<CR>")

vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})

-- vim.cmd("colorscheme catppuccin-macchiato")
vim.cmd("colorscheme ayu-mirage")
require('Comment').setup()

local on_attach = function(client)
    require'completion'.on_attach(client)
end

require("lspconfig").gopls.setup {}
require("lspconfig").lua_ls.setup {}
require("lspconfig").rust_analyzer.setup({
        on_attach = on_attach,
        settings = {
         ["rust-analyzer"] = {
                -- enable clippy on save
                -- checkOnSave = {
                --   command = "clippy",
                -- },
              },
        },
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local opts = {buffer = ev.buf}

      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>u', builtin.lsp_references, opts)
   end,
})

