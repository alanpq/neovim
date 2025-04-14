require("toggleterm").setup()

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true,

  direction = "float",
  persist_size = false,
  float_opts = {
    border = "curved",
    width = function ()
      return vim.o.columns
    end,
    height = function ()
      return vim.o.lines - 3
    end,
  },})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set({"n", "t"}, "<A-k>", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

