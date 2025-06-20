local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({

    -- Plugin Manager
    { "folke/lazy.nvim" },

    -- File explorer
    { "nvim-tree/nvim-tree.lua" },

    -- Status line
    { "nvim-lualine/lualine.nvim" },
    { "akinsho/bufferline.nvim",          version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

    -- LSP installer
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Rust
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false,
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
    },

    -- LSP
    { "neovim/nvim-lspconfig" },
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require("lspsaga").setup({})
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter", -- optional
            "nvim-tree/nvim-web-devicons", -- optional
        },
    },
    { "mfussenegger/nvim-dap" },
    { "jose-elias-alvarez/null-ls.nvim" },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter",     build = ":TSUpdate" },

    -- Completion engine plugins
    { "hrsh7th/nvim-cmp" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },

    -- Utilities
    { "akinsho/toggleterm.nvim",             version = "*",                                config = true },
    { "hiphish/rainbow-delimiters.nvim" },
    { "rcarriga/nvim-notify" },
    { "rmagatti/auto-session" },
    { "windwp/nvim-autopairs" },
    { "folke/trouble.nvim",                  dependencies = "kyazdani42/nvim-web-devicons" },
    { "nvim-lua/plenary.nvim" },
    { "numToStr/Comment.nvim" },

    { "lukas-reineke/indent-blankline.nvim", main = "ibl",                                 opts = {} },
    {
        "stevearc/conform.nvim",
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {},
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    },
    { "lewis6991/gitsigns.nvim" },
    { "NvChad/nvim-colorizer.lua" },
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            "MeanderingProgrammer/render-markdown.nvim",
        },
    },
    {
        'chipsenkbeil/distant.nvim',
        branch = 'v0.3',
        config = function()
            require('distant'):setup()
        end
    },
    -- Theme
    {
        "rebelot/kanagawa.nvim",
        config = function()
            vim.cmd([[colorscheme kanagawa-dragon]])
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
})
