local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
    LSP_ON_ATTACH(client, bufnr)
end

-- TypeScript
lspconfig["tsserver"].setup({
    on_attach = on_attach,
    root_dir = lspconfig.util.root_pattern("package.json"),
    cmd = { "pnpm", "typescript-language-server", "--stdio" },
    single_file_support = false,
    settings = {
        typescript = {
            format = {
                semicolons = "remove",
            },
        },
        javascript = {
            format = {
                semicolons = "remove",
            },
        },
    },
})

-- ESLint
lspconfig["eslint"].setup({
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
    end,
})
