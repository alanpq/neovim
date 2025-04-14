WK = require("which-key")
-- map leader to ,
WK.add({ " ", "<Nop>", { silent = true, remap = false } })
vim.g.mapleader = " "

vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode"})

WK.add({
  {
    mode = { "v" },
    -- move lines up/down
    { "J", ":m '>+1<CR>gv=gv" },
    { "K", ":m '<-2<CR>gv=gv" },
  },
  {
    { "C-d>", "<C-d>zz" },
    { "C-u>", "<C-u>zz" },
    { "n", "nzzzv" },
    { "N", "Nzzzv" },
    { "Q", "<nop>" },
  },
  {
    mode = { "x" },
    { "<leader>p", '"_dP' },
  },
})

-- colorizer
require("colorizer").setup()
WK.add({
  {
    { "<leader>c", "<cmd> ColorizerToggle<CR>", desc = "toggle Colorizer" },
  },
})

WK.setup()
