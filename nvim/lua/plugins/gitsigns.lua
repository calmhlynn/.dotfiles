require("gitsigns").setup({
	signcolumn = true,
	numhl = true,
	linehl = true,
	word_diff = false,

	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, "Next Hunk")

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, "Previous Hunk")

		map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Hunk")
		map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Hunk")

		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Stage Selected Hunk")

		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Reset Selected Hunk")

		map("n", "<leader>hS", gitsigns.stage_buffer, "Stage Buffer")
		map("n", "<leader>hR", gitsigns.reset_buffer, "Reset Buffer")
		map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Hunk")
		map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Preview Hunk Inline")

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, "Blame Line")

		map("n", "<leader>hd", gitsigns.diffthis, "Diff This")

		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, "Diff This (against HEAD~)")

		map("n", "<leader>hq", gitsigns.setqflist, "Hunks to Quickfix")

		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end, "All Hunks to Quickfix")

		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Line Blame")
		map("n", "<leader>tw", gitsigns.toggle_word_diff, "Toggle Word Diff")

		map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Hunk")
	end,
})
