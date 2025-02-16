return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "gopls", "clangd", "rust_analyzer"}
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Lua LSP
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" } -- Prevents "undefined global 'vim'"
                        }
                    }
                }
            })

            -- Go LSP
            lspconfig.gopls.setup({})

            -- C/C++ LSP
            lspconfig.clangd.setup({})

            -- Rust LSP
            lspconfig.rust_analyzer.setup({
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        checkOnSave = { command = "clippy" }
                    }
                }
            })

            -- Global LSP Keybindings
            local keymap = vim.keymap.set
            keymap('n', 'K', vim.lsp.buf.hover, {})
            keymap('n', 'gd', vim.lsp.buf.definition, {})
            keymap({ 'n', 'v' }, '<leader>cd', vim.lsp.buf.code_action, {})
            keymap('n', '<leader>rn', vim.lsp.buf.rename, {}) -- Rename symbol
            keymap('n', '<leader>f', function()
                vim.lsp.buf.format { async = true }
            end, {}) -- Format code
        end
    }
}

