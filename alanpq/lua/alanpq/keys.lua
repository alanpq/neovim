WK = require("which-key")
-- map leader to ,
WK.add({ " ", "<Nop>", { silent = true, remap = false } })
vim.g.mapleader = " "

WK.setup()

-- colorizer
require("colorizer").setup()
WK.add({
  {
    { "<leader>c", "<cmd> ColorizerToggle<CR>", desc = "toggle Colorizer" },
  },
})
