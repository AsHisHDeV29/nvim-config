-- Vim options
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true -- Converts tabs to spaces
vim.o.shiftwidth = 4   -- Indentation width
vim.o.tabstop = 4      -- Number of spaces per tab
vim.o.softtabstop = 4  -- Consistent indentation
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.smarttab = true    -- Automatically adjust the number of spaces when pressing Tab
vim.opt.breakindent = true -- Break long lines in a way that maintains indentation
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd([[syntax on]])
vim.cmd([[filetype plugin indent on]])
vim.g.mapleader = " "
-- keybinds
vim.keymap.set("i", "<C-k>", "<Esc>", { noremap = true, silent = true })
-- Ensure formatoptions 'r' is removed globally
vim.opt.formatoptions = vim.opt.formatoptions - "r" -- Alternative syntax, same effect

-- Set it after filetype detection to override any filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove("r") -- Enforce per buffer
    end,
    desc = "Ensure no auto-comment continuation for all filetypes",
})

-- Optional: Debug current formatoptions
vim.keymap.set("n", "<leader>fo", function()
    print("Current formatoptions: " .. vim.opt.formatoptions:get())
end, { desc = "Show current formatoptions" })
