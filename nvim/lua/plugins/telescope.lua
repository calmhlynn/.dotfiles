local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

local trouble = require("telescope")

-- configure telescope
telescope.setup({
	-- configure custom mappings
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-t>"] = trouble.open_with_trouble,
			},
			n = {
				["<C-t>"] = trouble.open_with_trouble,
			},
		},
	},
	pickers = {
		buffers = {
			sort_lastused = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("notify")

vim.keymap.set("i", [[<C-\><C-\>]], "<Esc>:Telescope commands<CR>", { noremap = true, silent = true })
vim.keymap.set("n", [[<C-\><C-\>]], ":Telescope commands<CR>", { noremap = true, silent = true })
vim.keymap.set("t", [[<C-\><C-\>]], "<C-\\><C-n>:Telescope commands<CR>", { noremap = true, silent = true })
vim.keymap.set("i", [[<C-\>s]], ":Telescope lsp_dynamic_workspace_symbols<CR>", { noremap = true, silent = true })
vim.keymap.set("n", [[<C-\>s]], ":Telescope lsp_dynamic_workspace_symbols<CR>", { noremap = true, silent = true })
vim.keymap.set("i", [[<C-\>g]], ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", [[<C-\>g]], ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("i", [[<C-\>f]], ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", [[<C-\>f]], ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("i", [[<C-\>d]], ":Telescope find_files no_ignore=true<CR>", { noremap = true, silent = true })
vim.keymap.set("n", [[<C-\>d]], ":Telescope find_files no_ignore=true<CR>", { noremap = true, silent = true })
vim.keymap.set("i", [[<C-\>b]], ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", [[<C-\>b]], ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.keymap.set("i", [[<C-\>p]], ":Telescope frecency<CR>", { noremap = true, silent = true }) -- p means "priority"
vim.keymap.set("n", [[<C-\>p]], ":Telescope frecency<CR>", { noremap = true, silent = true }) -- p means "priority"
vim.keymap.set("i", [[<C-]>]], "<Esc>:Telescope notify<CR>", { noremap = true, silent = true })
vim.keymap.set("n", [[<C-]>]], ":Telescope notify<CR>", { noremap = true, silent = true })
