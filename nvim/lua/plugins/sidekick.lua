return {
	"folke/sidekick.nvim",
	opts = {
		-- add any options here
		cli = {
			mux = {
				backend = "zellij",
				enabled = true,
			},
		},
	},
	keys = {
		{
			"<tab>",
			function()
				-- if there is a next edit, jump to it, otherwise apply it if any
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>" -- fallback to normal tab
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			"<c-.>",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			-- Or to select only installed tools:
			-- require("sidekick.cli").select({ filter = { installed = true } })
			desc = "Select CLI",
		},
		{
			"<leader>ad",
			function()
				require("sidekick.cli").close()
			end,
			desc = "Detach a CLI Session",
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
		{
			"<leader>aK",
			function()
				local State = require("sidekick.cli.state")
				local Session = require("sidekick.cli.session")

				local cwd = vim.fn.getcwd()

				local all_sessions = State.get()

				local matching_sessions = {}
				for _, state in ipairs(all_sessions) do
					if state.session and state.session.cwd == cwd then
						table.insert(matching_sessions, state)
					end
				end

				if #matching_sessions == 0 then
					vim.notify(
						"No sidekick session in current directory: " .. vim.fn.fnamemodify(cwd, ":t"),
						vim.log.levels.WARN
					)
					return
				end

				for _, state in ipairs(matching_sessions) do
					if state.session and state.session.sid then
						local session_id = state.session.sid
						-- Close the sidekick terminal if attached
						if state.attached then
							require("sidekick.cli").close()
						end
						-- Kill the zellij session
						vim.fn.system("zellij kill-session " .. vim.fn.shellescape(session_id))
						vim.notify(
							"Killed " .. state.tool.name .. " session in " .. vim.fn.fnamemodify(cwd, ":t"),
							vim.log.levels.INFO
						)
					end
				end
			end,
			desc = "Kill Sidekick Session in Current Dir",
		},
	},
}
