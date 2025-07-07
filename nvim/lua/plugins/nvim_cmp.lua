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
		opts = {
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = require("cmp").config.window.bordered(),
			},
			sources = require("cmp").config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "crates" },
				{ name = "buffer" },
			}),
			mapping = require("cmp").mapping.preset.insert({
				["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
				["<C-f>"] = require("cmp").mapping.scroll_docs(4),
				["<C-k>"] = require("cmp").mapping.complete(),
				["<C-e>"] = require("cmp").mapping.abort(),
				["<C-Space>"] = require("cmp").mapping.confirm({ select = true }),
				["<Tab>"] = require("cmp").mapping(function(fallback)
					if require("luasnip").locally_jumpable(1) then
						require("luasnip").jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = require("cmp").mapping(function(fallback)
					if require("luasnip").locally_jumpable(-1) then
						require("luasnip").jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
		},
	},
}
