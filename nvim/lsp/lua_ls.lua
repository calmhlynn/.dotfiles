local root_markers_lua = { ".emmyrc.json", ".luarc.json", ".luarc.jsonc" }
local root_markers_lint = { ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" }

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { root_markers_lua, root_markers_lint, { ".git" } },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
}
