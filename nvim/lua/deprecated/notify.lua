return {
	"rcarriga/nvim-notify",
	config = function()
		local stages_util = require("notify.stages.util")

		local function get_custom_stages(direction)
			return {
				function(state)
					local next_height = state.message.height + 2
					local next_row = stages_util.available_slot(state.open_windows, next_height, direction)
					if not next_row then
						return nil
					end
					return {
						relative = "editor",
						anchor = "NE",
						width = state.message.width,
						height = state.message.height,
						col = vim.opt.columns:get(),
						row = next_row,
						border = "rounded",
						style = "minimal",
						opacity = 0,
					}
				end,
				function()
					return {
						opacity = { 100 },
						col = { vim.opt.columns:get() },
					}
				end,
				function()
					return {
						col = { vim.opt.columns:get() },
						time = true,
					}
				end,
				function()
					return {
						opacity = {
							0,
							frequency = 2,
							complete = function(cur_opacity)
								return cur_opacity <= 4
							end,
						},
						col = { vim.opt.columns:get() },
					}
				end,
			}
		end

		require("notify").setup({
			stages = get_custom_stages("fade"), -- Assuming 'fade' as a default direction, adjust if needed
			timeout = 3000,
			background_colour = "#000000",
		})
		vim.notify = require("notify")
	end,
}
