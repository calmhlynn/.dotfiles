local colors = {
	dragonBlack = "#0D0C0C",
	dragonGray = "#A6A69C",
	dragonLightGray = "#C5C9C5",
	dragonBackground = "#181616",
	dragonForeground = "#c5c9c5",
	dragonRed = "#C4746E",
	dragonGreen = "#87A987",
	dragonYellow = "#C4B28A",
	dragonBlue = "#8BA4B0",
	dragonOrange = "#B6927B",
	inactiveGray = "#625e5a",
}

local shared_sections = {
	b = { bg = colors.dragonBackground, fg = colors.dragonLightGray },
	c = { bg = colors.dragonBackground, fg = colors.dragonLightGray },
}

local kanagawa_dragon = {
	normal = vim.tbl_extend("force", {
		a = { bg = colors.dragonGray, fg = colors.dragonBlack },
	}, shared_sections),

	insert = vim.tbl_extend("force", {
		a = { bg = colors.dragonRed, fg = colors.dragonBlack },
	}, shared_sections),

	visual = vim.tbl_extend("force", {
		a = { bg = colors.dragonOrange, fg = colors.dragonBlack },
	}, shared_sections),

	replace = vim.tbl_extend("force", {
		a = { bg = colors.dragonBlue, fg = colors.dragonBlack },
	}, shared_sections),

	command = vim.tbl_extend("force", {
		a = { bg = colors.dragonGreen, fg = colors.dragonBlack },
	}, shared_sections),

	inactive = {
		a = { bg = colors.inactiveGray, fg = colors.dragonGray },
		b = { bg = colors.inactiveGray, fg = colors.dragonGray },
		c = { bg = colors.inactiveGray, fg = colors.dragonGray },
	},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",

	config = function()
		require("lualine").setup({
			options = {
				theme = kanagawa_dragon,
			},
			sections = {
				lualine_a = {
					{
						"filename",
						file_status = true, -- displays file status (readonly status, modified status)
						path = 2, -- 0 = just filename, 1 = relative path, 2 = absolute path
					},
				},
			},
		})
	end,
}
