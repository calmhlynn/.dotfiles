return {

	"folke/trouble.nvim",
	dependencies = "kyazdani42/nvim-web-devicons",

	auto_preview = false,
	config = function()
		vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle<CR>", { silent = true, noremap = true })

		-- Trouble seems to have trouble with auto-session, so close when VimLeavePre
		vim.api.nvim_create_autocmd("VimLeavePre", { command = [[TroubleClose]] })
	end,
}
