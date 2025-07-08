return {
	"rmagatti/auto-session",
	log_level = "error",
	auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
	config = function()
		require("auto-session").setup({})
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
}
