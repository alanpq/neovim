WK = require("which-key")
-- map leader to ,
WK.add({ " ", "<Nop>", { silent = true, remap = false } })
vim.g.mapleader = " "

vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })

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

require("mini.bufremove").setup({})
WK.add({
	{ "<Tab>", ":BufferLineCycleNext<CR>", desc = "Next" },
	{ "<S-Tab>", ":BufferLineCyclePrev<CR>", desc = "Prev" },

	{ "<leader>b", desc = "Buffers" },
	{ "<leader>b1", "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Buffer 1" },
	{ "<leader>b2", "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Buffer 2" },
	{ "<leader>b3", "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Buffer 3" },
	{ "<leader>b4", "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Buffer 4" },
	{ "<leader>b5", "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Buffer 5" },
	{ "<leader>b6", "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Buffer 6" },
	{ "<leader>b7", "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Buffer 7" },
	{ "<leader>b8", "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Buffer 8" },
	{ "<leader>b9", "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Buffer 9" },
	{ "<leader>bc", ":BufferLinePick<CR>", desc = "Select buffer" },
	{ "<leader>bm", desc = "Buffer move" },
	{ "<leader>bmn", ":BufferLineMoveNext<CR>", desc = "Move forward" },
	{ "<leader>bmp", ":BufferLineMovePrev<CR>", desc = "Move back" },
	{ "<leader>bn", ":BufferLineCycleNext<CR>", desc = "Next" },
	{ "<leader>bp", ":BufferLineCyclePrev<CR>", desc = "Prev" },
	{ "<leader>bsd", ":BufferLineSortByDirectory<CR>", desc = "Sort by dir" },
	{ "<leader>bse", ":BufferLineSortByExtension<CR>", desc = "Sort by extension" },

	{ "<leader>x", desc = "Close buffer actions" },

	{ "<A-x>", "<cmd>lua MiniBufremove.delete()<CR>", desc = "Close active buffer" },
	{ "<leader>xx", "<cmd>lua MiniBufremove.delete()<CR>", desc = "Close active buffer" },

	{ "<leader>xh", "<cmd>BufferLineCloseLeft<CR>", desc = "Close all to left" },
	{ "<leader>xl", "<cmd>BufferLineCloseRight<CR>", desc = "Close all to right" },
	{ "<leader>xo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close others" },
})

-- colorizer
require("colorizer").setup()
WK.add({
	{
		{ "<leader>c", "<cmd> ColorizerToggle<CR>", desc = "toggle Colorizer" },
	},
})

WK.setup()
