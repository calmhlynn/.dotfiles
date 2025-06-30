local status_ok, kanagawa = pcall(require, "kanagawa")
if not status_ok then
	return
end

kanagawa.setup({
	overrides = function(colors)
		-- local theme = colors.theme
		return {
			Normal = { fg = colors.palette.dragonWhite, bg = colors.palette.dragonBlack3 },
			NormalFloat = { fg = colors.palette.fujiWhite, bg = colors.palette.dragonBlack3 },
			FloatBorder = { fg = colors.palette.fujiWhite, bg = colors.palette.dragonBlack3 },

			-- AvanteSidebarWinSeparator = { fg = colors.palette.fujiWhite, bg = colors.palette.dragonBlack3 },
		}
	end,
})
kanagawa.load("dragon")
