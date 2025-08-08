require("nvim-treesitter.configs").setup({
	modules = {},
	sync_install = false,
	ignore_install = {},
	ensure_installed = {},
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- rainbows

local highlight = {
	"RainbowDelimiterRed",
	"RainbowDelimiterYellow",
	"RainbowDelimiterBlue",
	"RainbowDelimiterOrange",
	"RainbowDelimiterGreen",
	"RainbowDelimiterViolet",
	"RainbowDelimiterCyan",
}

local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
	vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
end)

require("ibl").setup({
	scope = {
		enabled = true,
		show_start = true,
		show_end = true,
		injected_languages = true,
		highlight = highlight,
	},
})
vim.g.rainbow_delimiters = { highlight = highlight }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
