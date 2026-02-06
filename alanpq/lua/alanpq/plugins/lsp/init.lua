WK.add({
	{ "<leader>lg", desc = "Decs/Defs" },

	{
		"<leader>lgD",
		"<cmd>lua vim.lsp.buf.declaration()<CR>",
		desc = "Decleration",
	},
	{
		"<leader>lgd",
		"<cmd>lua vim.lsp.buf.definition()<CR>",
		desc = "Definition",
	},
	{
		"<leader>lgt",
		"<cmd>lua vim.lsp.buf.type_definition()<CR>",
		desc = "Type definition",
	},
	{
		"<leader>lgn",
		"<cmd>lua vim.diagnostic.goto_next()<CR>",
		desc = "Next diagnostic",
	},
	{
		"<leader>lgp",
		"<cmd>lua vim.diagnostic.goto_prev()<CR>",
		desc = "Prev diagnostic",
	},
	{ "<leader>lw", desc = "Workspace" },
	{
		"<leader>lwa",
		"<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
		desc = "Add workspace folder",
	},
	{
		"<leader>lwr",
		"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
		desc = "Remove workspace folder",
	},
	{
		"<leader>lwl",
		"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
		desc = "List workspace folders",
	},
	{
		"<leader>lh",
		"<cmd>lua vim.lsp.buf.hover()<CR>",
		desc = "Hover info",
	},
	{
		"<leader>ls",
		"<cmd>lua vim.lsp.buf.signature_help()<CR>",
		desc = "Signature info",
	},
	{
		"<leader>ln",
		"<cmd>lua vim.lsp.buf.rename()<CR>",
		desc = "Rename variable",
	},
	{
		"<leader>lf",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		desc = "Format buffer",
	},
	{ "<leader>l", desc = "LSP" },
	{
		"<leader>lT",
		(function()
			return function()
				vim.diagnostic.hide()
				vim.diagnostic.enable(not vim.diagnostic.is_enabled())
			end
		end)(),
		desc = "Toggle diagnostics",
	},
	{
		"<leader>lt",
		(function()
			return function()
				local enable = not vim.diagnostic.config().virtual_lines.current_line
				vim.diagnostic.config({
					underline = enable,
					virtual_lines = {
						current_line = enable,
					},
				})
			end
		end)(),
		desc = "Toggle virtual_lines",
	},
}, { noremap = true, silent = true })

local null_ls = require("null-ls")

-- code action sources
local code_actions = null_ls.builtins.code_actions

-- diagnostic sources
local diagnostics = null_ls.builtins.diagnostics

-- formatting sources
local formatting = null_ls.builtins.formatting

-- hover sources
-- local hover = null_ls.builtins.hover

-- completion sources
local completion = null_ls.builtins.completion

local ls_sources = {
	formatting.stylua,
	-- formatting.nixfmt,
	-- code_actions.gitsigns,
	diagnostics.statix,
	code_actions.statix,
	diagnostics.deadnix,
}

-- Enable null-ls
null_ls.setup({
	diagnostics_format = "[#{m}] #{s} (#{c})",
	debounce = 250,
	default_timeout = 5000,
	sources = ls_sources,
})
local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.diagnostic.config({
	float = { border = "single" },
	update_in_insert = true,
	virtual_text = false,
	virtual_lines = { enable = true, current_line = true },
	underline = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

-- Nix (nil) config

vim.lsp.config("nil_ls", {
	capabilities = capabilities,
	cmd = { "nil" },
	settings = {
		["nil"] = {
			nix = {
				binary = "nix",
				maxMemoryMB = nil,
				flake = {
					autoEvalInputs = false,
					autoArchive = false,
					nixpkgsInputName = nil,
				},
			},
			formatting = {
				command = { "nixfmt", "--quiet" },
			},
		},
	},
})
vim.lsp.enable("nil_ls")

-- Lua
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			format = {
				enable = true,
			},
			runtime = {
				version = "LuaJIT",
			},
			telemetry = { enable = false },
			workspace = {
				checkThirdParty = false,
			},
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				disable = { "missing-fields" },
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
vim.lsp.enable("lua_ls")

-- Rust config
require("crates").setup({
	lsp = {
		enabled = true,
		actions = true,
		completion = true,
		hover = true,
	},
})

vim.g.rustaceanvim = {
	tools = {
		code_actions = {
			ui_select_fallback = true,
		},
	},
	server = {
		default_settings = {
			["rust-analyzer"] = {
				assist = {
					importGranularity = "crate",
					importEnforceGranularity = true,
				},
				inlayHints = {
					typeHints = { enable = true },
					chainingHints = { enable = true },
					bindingModeHints = { enable = true },
					closureReturnTypeHints = { enable = "always" },
					lifetimeElisionHints = { enable = "always" },
					maxLength = 5,
					enable = true,
				},
				lens = { enable = true },
				checkOnSave = {
					command = "clippy",
					allFeatures = true,
				},
			},
		},
	},
	on_attach = function(_, bufnr)
		WK.add({
			{ "<leader>r", desc = "Rust" },
			{
				"<leader>rr",
				":RustLsp runnables<CR>",
				desc = "Runnables",
			},
			{
				"<leader>rp",
				":RustLsp parentModule<CR>",
				desc = "Parent module",
			},
			{
				"<leader>rm",
				":RustLsp expandMacro<CR>",
				desc = "Expand macro",
			},
			{
				"<leader>rc",
				":RustLsp openCargo",
				desc = "Open crate",
			},
			{
				"<leader>rg",
				":RustLsp crateGraph x11",
				desc = "Crate graph",
			},
			{
				"<leader>rd",
				":RustLsp debuggables<cr>",
				desc = "Debuggables",
			},
		}, { noremap = true, silent = true, buffer = bufnr })
	end,
}
-- CCLS (clang) config

vim.lsp.config("ccls", {
	capabilities = capabilities,
	cmd = { "ccls" },
})
vim.lsp.enable("ccls")

vim.lsp.config("jsonls", {
	capabilities = capabilities,
})
vim.lsp.enable("jsonls")

-- Python config
vim.lsp.config("basedpyright", {
	capabilities = capabilities,
})
vim.lsp.enable("basedpyright")

vim.lsp.enable("qmlls")

vim.lsp.enable("tailwindcss")
vim.lsp.enable("svelte")
require("typescript-tools").setup({
	on_attach = function() end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"svelte",
	},
	handlers = {},
	settings = {
		-- spawn additional tsserver instance to calculate diagnostics on it
		separate_diagnostic_server = true,
		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
		publish_diagnostic_on = "insert_leave",
		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
		-- "remove_unused_imports"|"organize_imports") -- or string "all"
		-- to include all supported code actions
		-- specify commands exposed as code_actions
		expose_as_code_action = {},
		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
		-- not exists then standard path resolution strategy is applied
		tsserver_path = nil,
		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
		-- (see 💅 `styled-components` support section)
		tsserver_plugins = {
			"typescript-svelte-plugin",
		},
		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
		-- memory limit in megabytes or "auto"(basically no limit)
		tsserver_max_memory = "auto",
		-- described below
		tsserver_format_options = {},
		tsserver_file_preferences = {},
		-- locale of all tsserver messages, supported locales you can find here:
		-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
		tsserver_locale = "en",
		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
		complete_function_calls = false,
		include_completions_with_insert_text = true,
		-- CodeLens
		-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
		-- possible values: ("off"|"all"|"implementations_only"|"references_only")
		code_lens = "off",
		-- by default code lenses are displayed on all referencable values and for some of you it can
		-- be too much this option reduce count of them by removing member references from lenses
		disable_member_code_lens = true,
		-- JSXCloseTag
		-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
		-- that maybe have a conflict if enable this feature. )
		jsx_close_tag = {
			enable = false,
			filetypes = { "javascriptreact", "typescriptreact" },
		},
	},
})
