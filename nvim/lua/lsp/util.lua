local M = {}

--- Prefer a project-local binary from node_modules/.bin over the global one.
function M.node_cmd(binary)
	return function(dispatchers, config)
		local cmd = binary
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", binary)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end
		return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
	end
end

return M
