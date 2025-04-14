require("toggleterm").setup()

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	hidden = true,

	direction = "float",
	persist_size = false,
	float_opts = {
		border = "curved",
		width = function()
			return vim.o.columns
		end,
		height = function()
			return vim.o.lines - 3
		end,
	},
})

function _lazygit_toggle()
	lazygit:toggle()
end

vim.keymap.set({ "n", "t" }, "<A-k>", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

local floating = Terminal:new({
	hidden = true,
	direction = "float",
	persist_size = false,
	float_opts = {
		border = "curved",
		width = function()
			return vim.o.columns
		end,
		height = function()
			return vim.o.lines - 3
		end,
	},
})

function _floating_toggle()
	floating:toggle()
end
WK.add({
	mode = { "n", "t" },
	"<A-i>",
	"<cmd>lua _floating_toggle()<CR>",
	{ noremap = true, silent = true },
})
