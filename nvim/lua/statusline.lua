local M = {}

local colors = {
	dragonBlack = "#0D0C0C",
	dragonGray = "#A6A69C",
	dragonLightGray = "#C5C9C5",
	dragonBackground = "#181616",
	dragonRed = "#C4746E",
	dragonGreen = "#87A987",
	dragonBlue = "#8BA4B0",
	dragonOrange = "#B6927B",
	inactiveGray = "#625e5a",
}

local group = vim.api.nvim_create_augroup("builtin_statusline", { clear = true })

local function escape(text)
	return text:gsub("%%", "%%%%")
end

local function context()
	local winid = tonumber(vim.g.statusline_winid or 0)

	if winid == 0 or not vim.api.nvim_win_is_valid(winid) then
		winid = vim.api.nvim_get_current_win()
	end

	return {
		winid = winid,
		bufnr = vim.api.nvim_win_get_buf(winid),
		active = winid == vim.api.nvim_get_current_win(),
	}
end

local function mode_state()
	local mode = vim.api.nvim_get_mode().mode
	local prefix = mode:sub(1, 1)

	if prefix == "i" then
		return "StatusLineFileInsert", "I"
	end

	if prefix == "v" or prefix == "V" or mode == "\22" then
		return "StatusLineFileVisual", "V"
	end

	if prefix == "R" then
		return "StatusLineFileReplace", "R"
	end

	if prefix == "c" then
		return "StatusLineFileCommand", "C"
	end

	return "StatusLineFileNormal", "N"
end

local function filename(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)

	if name == "" then
		return "[No Name]"
	end

	return vim.fn.fnamemodify(name, ":p")
end

local function file_segment(ctx, mode_label)
	local prefix = mode_label ~= "" and (" " .. mode_label) or ""
	return prefix .. " %<" .. escape(filename(ctx.bufnr)) .. " %h%w%m%r "
end

local function separator()
	return "%#StatusLineSeparator#|"
end

local function text_segment(hl, text)
	if text == "" then
		return ""
	end

	return "%#" .. hl .. "# " .. escape(text) .. " "
end

local function fmt_segment(hl, fmt)
	return "%#" .. hl .. "# " .. fmt .. " "
end

local function git_segment(ctx)
	local head = vim.b[ctx.bufnr].gitsigns_head
	local status = vim.b[ctx.bufnr].gitsigns_status_dict
	local parts = {}

	if head and head ~= "" then
		table.insert(parts, "%#StatusLineGit# git:" .. escape(head))
	end

	if type(status) == "table" then
		if (status.added or 0) > 0 then
			table.insert(parts, "%#StatusLineDiffAdd# +" .. status.added)
		end
		if (status.changed or 0) > 0 then
			table.insert(parts, "%#StatusLineDiffChange# ~" .. status.changed)
		end
		if (status.removed or 0) > 0 then
			table.insert(parts, "%#StatusLineDiffDelete# -" .. status.removed)
		end
	end

	if #parts == 0 then
		return ""
	end

	return separator() .. " " .. table.concat(parts, " ") .. " "
end

local function diagnostic_segment(ctx)
	local ok_count, counts = pcall(vim.diagnostic.count, ctx.bufnr)
	if not ok_count or type(counts) ~= "table" or not next(counts) then
		return ""
	end

	local severities = {
		{ key = vim.diagnostic.severity.ERROR, label = "E", hl = "StatusLineDiagError" },
		{ key = vim.diagnostic.severity.WARN, label = "W", hl = "StatusLineDiagWarn" },
		{ key = vim.diagnostic.severity.INFO, label = "I", hl = "StatusLineDiagInfo" },
		{ key = vim.diagnostic.severity.HINT, label = "H", hl = "StatusLineDiagHint" },
	}
	local parts = {}

	for _, item in ipairs(severities) do
		local count = counts[item.key] or 0
		if count > 0 then
			table.insert(parts, "%#" .. item.hl .. "# " .. item.label .. count)
		end
	end

	if #parts == 0 then
		return ""
	end

	return separator() .. table.concat(parts, "") .. " "
end

local function progress_segment()
	local ok, status = pcall(vim.ui.progress_status)
	if not ok or status == "" then
		return ""
	end

	return separator() .. text_segment("StatusLineProgress", status)
end

local function meta_segment(ctx)
	local parts = {}
	local bo = vim.bo[ctx.bufnr]
	local encoding = bo.fileencoding ~= "" and bo.fileencoding or vim.o.encoding

	if encoding ~= "" then
		table.insert(parts, encoding)
	end

	if bo.fileformat ~= "" then
		table.insert(parts, bo.fileformat)
	end

	if bo.filetype ~= "" then
		table.insert(parts, bo.filetype)
	end

	if #parts == 0 then
		return ""
	end

	return text_segment("StatusLineMeta", table.concat(parts, " "))
end

function M.render()
	local ctx = context()

	if not ctx.active then
		return "%#StatusLineFileInactive#" .. file_segment(ctx, "") .. "%#StatusLineNC#%=%l:%c "
	end

	local mode_hl, mode_label = mode_state()
	local sections = {
		"%#" .. mode_hl .. "#",
		file_segment(ctx, mode_label),
		"%#StatusLineBase#",
	}

	local git = git_segment(ctx)
	if git ~= "" then
		table.insert(sections, git)
	end

	local diagnostics = diagnostic_segment(ctx)
	if diagnostics ~= "" then
		table.insert(sections, diagnostics)
	end

	local progress = progress_segment()
	if progress ~= "" then
		table.insert(sections, progress)
	end

	table.insert(sections, "%=")

	local meta = meta_segment(ctx)
	if meta ~= "" then
		table.insert(sections, meta)
	end

	table.insert(sections, separator())
	table.insert(sections, fmt_segment("StatusLinePos", "%l:%c %P"))

	return table.concat(sections)
end

function M.apply_highlights()
	vim.api.nvim_set_hl(0, "StatusLineBase", {
		bg = colors.dragonBackground,
		fg = colors.dragonLightGray,
	})
	vim.api.nvim_set_hl(0, "StatusLine", {
		bg = colors.dragonBackground,
		fg = colors.dragonLightGray,
	})
	vim.api.nvim_set_hl(0, "StatusLineNC", {
		bg = colors.inactiveGray,
		fg = colors.dragonGray,
	})
	vim.api.nvim_set_hl(0, "StatusLineSeparator", {
		bg = colors.dragonBackground,
		fg = colors.dragonGray,
	})
	vim.api.nvim_set_hl(0, "StatusLineGit", {
		bg = colors.dragonBackground,
		fg = colors.dragonGreen,
	})
	vim.api.nvim_set_hl(0, "StatusLineDiffAdd", {
		bg = colors.dragonBackground,
		fg = colors.dragonGreen,
	})
	vim.api.nvim_set_hl(0, "StatusLineDiffChange", {
		bg = colors.dragonBackground,
		fg = colors.dragonOrange,
	})
	vim.api.nvim_set_hl(0, "StatusLineDiffDelete", {
		bg = colors.dragonBackground,
		fg = colors.dragonRed,
	})
	vim.api.nvim_set_hl(0, "StatusLineDiagError", {
		bg = colors.dragonBackground,
		fg = colors.dragonRed,
	})
	vim.api.nvim_set_hl(0, "StatusLineDiagWarn", {
		bg = colors.dragonBackground,
		fg = colors.dragonOrange,
	})
	vim.api.nvim_set_hl(0, "StatusLineDiagInfo", {
		bg = colors.dragonBackground,
		fg = colors.dragonBlue,
	})
	vim.api.nvim_set_hl(0, "StatusLineDiagHint", {
		bg = colors.dragonBackground,
		fg = colors.dragonGreen,
	})
	vim.api.nvim_set_hl(0, "StatusLineProgress", {
		bg = colors.dragonBackground,
		fg = colors.dragonOrange,
	})
	vim.api.nvim_set_hl(0, "StatusLineMeta", {
		bg = colors.inactiveGray,
		fg = colors.dragonLightGray,
	})
	vim.api.nvim_set_hl(0, "StatusLinePos", {
		bg = colors.dragonGray,
		fg = colors.dragonBlack,
	})
	vim.api.nvim_set_hl(0, "StatusLineFileNormal", {
		bg = colors.dragonGray,
		fg = colors.dragonBlack,
	})
	vim.api.nvim_set_hl(0, "StatusLineFileInsert", {
		bg = colors.dragonRed,
		fg = colors.dragonBlack,
	})
	vim.api.nvim_set_hl(0, "StatusLineFileVisual", {
		bg = colors.dragonOrange,
		fg = colors.dragonBlack,
	})
	vim.api.nvim_set_hl(0, "StatusLineFileReplace", {
		bg = colors.dragonBlue,
		fg = colors.dragonBlack,
	})
	vim.api.nvim_set_hl(0, "StatusLineFileCommand", {
		bg = colors.dragonGreen,
		fg = colors.dragonBlack,
	})
	vim.api.nvim_set_hl(0, "StatusLineFileInactive", {
		bg = colors.inactiveGray,
		fg = colors.dragonGray,
	})
end

function M.setup()
	M.apply_highlights()

	vim.o.statusline = "%!v:lua.require('statusline').render()"

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = M.apply_highlights,
	})
end

return M
