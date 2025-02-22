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
				ensure_installed = { "lua_ls", "gopls", "clangd", "rust_analyzer" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }

				-- Keybindings for LSP
				local keymap = vim.keymap.set
				keymap("n", "K", vim.lsp.buf.hover, opts)
				keymap("n", "gd", vim.lsp.buf.definition, opts)
				keymap("n", "gr", vim.lsp.buf.references, opts)
				keymap("n", "gi", vim.lsp.buf.implementation, opts)
				keymap({ "n", "v" }, "<leader>cd", vim.lsp.buf.code_action, opts)
				keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
				keymap("n", "<leader>f", function()
					vim.lsp.buf.format({ async = false, bufnr = bufnr }) -- Synchronous for consistency
				end, opts)
			end

			-- LSP Servers Setup
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					gopls = {
						gofumpt = true, -- Stricter Go formatting
					},
				},
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { "clangd", "--background-index" },
			})

			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					["rust-analyzer"] = {
						diagnostics = { enable = true },
						cargo = { allFeatures = true },
						checkOnSave = { command = "clippy" },
						procMacro = { enable = true },
					},
				},
			})

			-- Global autocommand for formatting on InsertLeave
			vim.api.nvim_create_autocmd("InsertLeave", {
				pattern = { "*.rs", "*.go", "*.c", "*.cpp", "*.h", "*.hpp" },
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					-- Check if an LSP client with formatting capability is attached
					for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
						if client.server_capabilities.documentFormattingProvider then
							vim.lsp.buf.format({ async = false, bufnr = bufnr })
							return -- Exit after formatting once
						end
					end
				end,
			})
		end,
	},
}
