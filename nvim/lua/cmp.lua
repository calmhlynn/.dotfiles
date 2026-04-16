vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.complete = ".,b,f"

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
			vim.api.nvim_create_autocmd("InsertCharPre", {
				group = vim.api.nvim_create_augroup("lsp_completion_trigger_" .. ev.buf, { clear = true }),
				buffer = ev.buf,
				callback = function()
					vim.schedule(vim.lsp.completion.get)
				end,
			})
		end
	end,
})

-- Workaround: completeopt=popup info window border
-- (completepopup option not yet ported to Neovim: neovim/neovim#38248)
local function set_popup_border(winid)
	if winid and winid >= 0 and vim.api.nvim_win_is_valid(winid) then
		pcall(vim.api.nvim_win_set_config, winid, { border = "rounded" })
	end
end

vim.api.nvim_create_autocmd("CompleteChanged", {
	group = vim.api.nvim_create_augroup("completion_popup_border", { clear = true }),
	callback = function()
		vim.schedule(function()
			local info = vim.fn.complete_info({ "selected" })
			set_popup_border(info.preview_winid)
		end)
	end,
})

if vim.api.nvim__complete_set then
	local orig = vim.api.nvim__complete_set
	vim.api.nvim__complete_set = function(index, opts)
		local windata = orig(index, opts)
		set_popup_border(windata and windata.winid)
		return windata
	end
end

-- Confirm selection
vim.keymap.set("i", "<C-Space>", function()
	return vim.fn.pumvisible() == 1 and "<C-y>" or "<C-Space>"
end, { expr = true, desc = "Confirm completion" })

-- Snippet jumping (vim.snippet replaces LuaSnip)
vim.keymap.set({ "i", "s" }, "<Tab>", function()
	if vim.snippet.active({ direction = 1 }) then
		return "<Cmd>lua vim.snippet.jump(1)<CR>"
	end
	return "<Tab>"
end, { expr = true, desc = "Jump to next snippet placeholder" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if vim.snippet.active({ direction = -1 }) then
		return "<Cmd>lua vim.snippet.jump(-1)<CR>"
	end
	return "<S-Tab>"
end, { expr = true, desc = "Jump to previous snippet placeholder" })
