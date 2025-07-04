-- -- configure telescope
-- telescope.setup({
-- 	-- configure custom mappings
-- 	defaults = {
-- 		mappings = {
-- 			i = {
-- 				["<C-k>"] = actions.move_selection_previous, -- move to prev result
-- 				["<C-j>"] = actions.move_selection_next, -- move to next result
-- 				["<C-t>"] = trouble.open_with_trouble,
-- 			},
-- 			n = {
-- 				["<C-t>"] = trouble.open_with_trouble,
-- 			},
-- 		},
-- 	},
-- 	pickers = {
-- 		buffers = {
-- 			sort_lastused = true,
-- 		},
-- 	},
-- 	extensions = {
-- 		fzf = {
-- 			fuzzy = true, -- false will only do exact matching
-- 			override_generic_sorter = true, -- override the generic sorter
-- 			override_file_sorter = true, -- override the file sorter
-- 			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
-- 			-- the default case_mode is "smart_case"
-- 		},
-- 	},
-- })
--
-- telescope.load_extension("fzf")
-- telescope.load_extension("notify")
--
-- vim.keymap.set("i", [[<C-\><C-\>]], "<Esc>:Telescope commands<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", [[<C-\><C-\>]], ":Telescope commands<CR>", { noremap = true, silent = true })
-- vim.keymap.set("t", [[<C-\><C-\>]], "<C-\\><C-n>:Telescope commands<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", [[<C-\>s]], ":Telescope lsp_dynamic_workspace_symbols<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", [[<C-\>s]], ":Telescope lsp_dynamic_workspace_symbols<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", [[<C-\>g]], ":Telescope live_grep<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", [[<C-\>g]], ":Telescope live_grep<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", [[<C-\>f]], ":Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", [[<C-\>f]], ":Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", [[<C-\>d]], ":Telescope find_files no_ignore=true<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", [[<C-\>d]], ":Telescope find_files no_ignore=true<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", [[<C-\>b]], ":Telescope buffers<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", [[<C-\>b]], ":Telescope buffers<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", [[<C-\>p]], ":Telescope frecency<CR>", { noremap = true, silent = true }) -- p means "priority"
-- vim.keymap.set("n", [[<C-\>p]], ":Telescope frecency<CR>", { noremap = true, silent = true }) -- p means "priority"
-- vim.keymap.set("i", [[<C-]>]], "<Esc>:Telescope notify<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", [[<C-]>]], ":Telescope notify<CR>", { noremap = true, silent = true })
return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			-- From telescope.setup.defaults.mappings.i
			{
				"i",
				"<C-k>",
				function()
					require("telescope.actions").move_selection_previous()
				end,
				desc = "Telescope: Prev result (insert)",
			},
			{
				"i",
				"<C-j>",
				function()
					require("telescope.actions").move_selection_next()
				end,
				desc = "Telescope: Next result (insert)",
			},
			{
				"i",
				"<C-t>",
				function()
					require("telescope").open_with_trouble()
				end,
				desc = "Telescope: Open with Trouble (insert)",
			},
			-- From telescope.setup.defaults.mappings.n
			{
				"n",
				"<C-t>",
				function()
					require("telescope").open_with_trouble()
				end,
				desc = "Telescope: Open with Trouble (normal)",
			},

			-- From vim.keymap.set calls
			{ "i", "<C-\\><C-\\>", "<Esc>:Telescope commands<CR>", desc = "Telescope: Commands (insert)" },
			{ "n", "<C-\\><C-\\>", ":Telescope commands<CR>", desc = "Telescope: Commands (normal)" },
			{
				"t",
				"<C-\\><C-\\>",
				"<C-\\><C-n>:Telescope commands<CR>",
				desc = "Telescope: Commands (terminal)",
			},
			{
				"i",
				"<C-\\>s",
				":Telescope lsp_dynamic_workspace_symbols<CR>",
				desc = "Telescope: LSP Workspace Symbols (insert)",
			},
			{
				"n",
				"<C-\\>s",
				":Telescope lsp_dynamic_workspace_symbols<CR>",
				desc = "Telescope: LSP Workspace Symbols (normal)",
			},
			{ "i", "<C-\\>g", ":Telescope live_grep<CR>", desc = "Telescope: Live Grep (insert)" },
			{ "n", "<C-\\>g", ":Telescope live_grep<CR>", desc = "Telescope: Live Grep (normal)" },
			{ "i", "<C-\\>f", ":Telescope find_files<CR>", desc = "Telescope: Find Files (insert)" },
			{ "n", "<C-\\>f", ":Telescope find_files<CR>", desc = "Telescope: Find Files (normal)" },
			{
				"i",
				"<C-\\>d",
				":Telescope find_files no_ignore=true<CR>",
				desc = "Telescope: Find Files (no ignore, insert)",
			},
			{
				"n",
				"<C-\\>d",
				":Telescope find_files no_ignore=true<CR>",
				desc = "Telescope: Find Files (no ignore, normal)",
			},
			{ "i", "<C-\\>b", ":Telescope buffers<CR>", desc = "Telescope: Buffers (insert)" },
			{ "n", "<C-\\>b", ":Telescope buffers<CR>", desc = "Telescope: Buffers (normal)" },
			{ "i", "<C-\\>p", ":Telescope frecency<CR>", desc = "Telescope: Frecency (insert)" },
			{ "n", "<C-\\>p", ":Telescope frecency<CR>", desc = "Telescope: Frecency (normal)" },
			{ "i", "<C-]>", "<Esc>:Telescope notify<CR>", desc = "Telescope: Notify (insert)" },
			{ "n", "<C-]>", ":Telescope notify<CR>", desc = "Telescope: Notify (normal)" },
		},
		config = function()
			-- Ensure required modules are loaded within the config
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local trouble = require("telescope")

			telescope.setup({
				pickers = {
					buffers = {
						sort_lastused = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("notify")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
	},
}
