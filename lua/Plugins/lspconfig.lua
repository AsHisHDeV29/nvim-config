return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "rust_analyzer", "lua_ls", "gopls", "clangd", "ts_ls", "pyright" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/nvim-cmp", "nvim-telescope/telescope.nvim" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            local original_notify = vim.notify
            vim.notify = function(msg, log_level)
                if msg:match("null-ls") or msg:match("supports") or msg:match("attached to buffer") then
                    return
                end
                original_notify(msg, log_level)
            end

            local on_attach = function(client, bufnr)
                if not vim.bo[bufnr].modifiable then
                    return
                end
                local opts = { buffer = bufnr, noremap = true, silent = true }
                vim.keymap.set("n", "<Leader>cd", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "<Leader>co", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<Leader>cf", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
            end

            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("Cargo.toml"),
                settings = { ["rust-analyzer"] = { checkOnSave = { command = "clippy" } } },
                on_attach = on_attach,
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern(".git", "*.lua"),
                settings = { Lua = { diagnostics = { globals = { "vim" } } } },
                on_attach = on_attach,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
                settings = { gopls = { gofumpt = true } },
                on_attach = on_attach,
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
                on_attach = on_attach,
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
                on_attach = on_attach,
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern(
                    "pyproject.toml",
                    "setup.py",
                    "requirements.txt",
                    ".git",
                    "*.py"
                ),
                on_attach = on_attach,
            })

            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = {
                    "*.rs",
                    "*.lua",
                    "*.go",
                    "*.c",
                    "*.cpp",
                    "*.h",
                    "*.hpp",
                    "*.ts",
                    "*.tsx",
                    "*.js",
                    "*.jsx",
                    "*.py",
                },
                callback = function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    if not vim.bo[bufnr].modifiable then
                        return
                    end
                    vim.schedule(function()
                        vim.lsp.buf.code_action({ apply = true, context = { only = { "quickfix" } } })
                    end)
                end,
            })
        end,
    },
}
