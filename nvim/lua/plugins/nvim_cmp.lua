return {

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "crates" },
					{ name = "buffer" },
				}),
			})

			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "git" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
		keys = {
			{
				"<C-b>",
				function()
					local cmp = require("cmp")
					cmp.mapping.scroll_docs(-4)()
				end,
				mode = "i",
				desc = "Scroll docs up",
			},
			{
				"<C-f>",
				function()
					local cmp = require("cmp")
					cmp.mapping.scroll_docs(4)()
				end,
				mode = "i",
				desc = "Scroll docs down",
			},
			{
				"<C-k>",
				function()
					local cmp = require("cmp")
					cmp.mapping.complete()
				end,
				mode = "i",
				desc = "Complete",
			},
			{
				"<C-e>",
				function()
					local cmp = require("cmp")
					cmp.mapping.abort()
				end,
				mode = "i",
				desc = "Abort",
			},
			{
				"<C-Space>",
				function()
					local cmp = require("cmp")
					cmp.mapping.confirm({ select = true })
				end,
				mode = "i",
				desc = "Confirm",
			},
			-- {
			-- 	"<Tab>",
			-- 	function()
			-- 		local luasnip = require("luasnip")
			-- 		local cmp = require("cmp")
			-- 		if luasnip.locally_jumpable(1) then
			-- 			luasnip.jump(1)
			-- 		else
			-- 			cmp.mapping.fallback()
			-- 		end
			-- 	end,
			-- 	mode = { "i", "s" },
			-- 	desc = "Next snippet / Fallback",
			-- },
			-- {
			-- 	"<S-Tab>",
			-- 	function()
			-- 		local luasnip = require("luasnip")
			-- 		local cmp = require("cmp")
			-- 		if luasnip.locally_jumpable(-1) then
			-- 			luasnip.jump(-1)
			-- 		else
			-- 			cmp.mapping.fallback()
			-- 		end
			-- 	end,
			-- 	mode = { "i", "s" },
			-- 	desc = "Previous snippet / Fallback",
			-- },
		},
	},
}
