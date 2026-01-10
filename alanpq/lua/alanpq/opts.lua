vim.opt.number = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.spell = true
vim.opt.spelllang = "en_gb"

vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 10

-- https://github.com/neovim/neovim/issues/14433
vim.g.omni_sql_default_compl_type = "syntax"

--theming
vim.opt.termguicolors = true

vim.g.moonflyCursorColor = true
vim.g.moonflyNormalFloat = true
vim.g.moonflyTerminalColors = true
vim.g.moonflyTransparent = true
vim.g.moonflyUndercurls = true
vim.g.moonflyUnderlineMatchParen = true
vim.g.moonflyVirtualTextColor = true
vim.cmd.colorscheme("moonfly")
