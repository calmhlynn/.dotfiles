local status_ok, kanagawa = pcall(require, "kanagawa")
if not status_ok then
	return
end

kanagawa.setup({
	overrides = function(colors)
		-- local theme = colors.theme
		return {
			NormalFloat = { fg = colors.palette.dragonWhite, bg = colors.palette.dragonBlack3 },
			FloatBorder = { fg = colors.palette.dragonWhite, bg = colors.palette.dragonBlack3 },
			LspInfoBorder = { fg = colors.palette.dragonWhite, bg = colors.palette.dragonBlack3 },
		}
	end,
})
kanagawa.load("dragon")
