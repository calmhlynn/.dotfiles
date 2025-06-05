require("avante").setup({

    provider = "claude",
    mode = "legacy", -- "agentic" is too much and expensive..
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
        }
    }
})
