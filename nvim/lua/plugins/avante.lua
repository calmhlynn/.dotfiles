require("avante").setup({

	provider = "gemini",
	mode = "agentic", -- legacy
	providers = {
		claude = {
			model = "claude-sonnet-4-20250514",
			api_key_name = "cmd:pass show api_tokens/claude",
			disable_tools = true,
		},
		openai = {
			model = "o4-mini-2025-04-16",
			api_key_name = "cmd:pass show api_tokens/openai",
			-- disable_tools = true,
		},
		gemini = {
			model = "gemini-2.5-flash",
			api_key_name = "cmd:security find-generic-password -s GEMINI -a calmhlynn -w",
		},
	},
	behaviour = {
		auto_set_highlight_group = false,
	},
})

-- kanagawa-dragon
local status_ok, _ = pcall(require, "avante")
if status_ok then
	vim.api.nvim_set_hl(0, "AvanteTitle", { fg = "#c5c9c5" })
	vim.api.nvim_set_hl(0, "AvanteReversedTitle", { bg = "#c5c9c5", fg = "#181616" })
	vim.api.nvim_set_hl(0, "AvanteSubtitle", { fg = "#8ba4b0" })
	vim.api.nvim_set_hl(0, "AvanteReversedSubtitle", { bg = "#8ba4b0", fg = "#181616" })
	vim.api.nvim_set_hl(0, "AvanteThirdTitle", { fg = "#a292a3" })
	vim.api.nvim_set_hl(0, "AvanteConflictCurrent", { bg = "#2a3238" })
	vim.api.nvim_set_hl(0, "AvanteConflictCurrentLabel", { fg = "#c4746e" })
	vim.api.nvim_set_hl(0, "AvanteConflictIncoming", { bg = "#263439" })
	vim.api.nvim_set_hl(0, "AvanteConflictIncomingLabel", { fg = "#8a9a7b" })
	vim.api.nvim_set_hl(0, "AvantePopupHint", { fg = "#a6a69c" })
	vim.api.nvim_set_hl(0, "AvanteInlineHint", { fg = "#a6a69c" })
	vim.api.nvim_set_hl(0, "AvantePromptInput", { fg = "#c5c9c5" })
	vim.api.nvim_set_hl(0, "AvantePromptInputBorder", { fg = "#8ba4b0" })
end
