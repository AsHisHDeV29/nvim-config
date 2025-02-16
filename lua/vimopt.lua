--Vim options

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.smarttab = true   -- Automatically adjust the number of spaces when pressing Tab
vim.opt.breakindent = true  -- Break long lines in a way that maintains indentation
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
