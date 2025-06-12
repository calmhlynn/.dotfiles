-- C/C++ file type settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp" },
    callback = function()
        -- Set indentation settings for C/C++ files
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true -- Use spaces instead of tabs
    end,
})
