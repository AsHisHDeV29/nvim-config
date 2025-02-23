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
				ensure_installed = { "rust_analyzer", "lua_ls", "gopls", "clangd" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Rust Analyzer
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern("Cargo.toml"),
				settings = {
					["rust-analyzer"] = {
						diagnostics = { enable = true },
						cargo = { allFeatures = true },
						checkOnSave = { command = "clippy" },
						procMacro = { enable = true },
						imports = { granularity = { group = "module" }, prefix = "self" },
						workspace = { symbol = { search = { kind = "all_symbols" } } },
					},
				},
				on_attach = function(client, bufnr)
					-- Guard against premature execution
					if client.server_capabilities.executeCommandProvider then
						vim.lsp.buf.execute_command({ command = "rust-analyzer.reloadWorkspace" })
						vim.notify("Rust-analyzer initialized", vim.log.levels.INFO)
					else
						vim.notify("Rust-analyzer not fully attached yet", vim.log.levels.WARN)
					end
				end,
			})

			-- Lua Language Server
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern(".git", "*.lua"),
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			})

			-- Go Language Server (gopls)
			lspconfig.gopls.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
				settings = { gopls = { gofumpt = true } },
			})

			-- Clangd (C/C++)
			lspconfig.clangd.setup({
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
				cmd = { "clangd", "--background-index" },
			})

			-- Autocommands
			vim.o.autoread = true
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
				pattern = "*",
				command = "checktime",
			})
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.rs", "*.lua", "*.go", "*.c", "*.cpp", "*.h", "*.hpp" },
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					vim.notify("Reloading LSP for " .. vim.bo.filetype, vim.log.levels.INFO)
					vim.schedule(function()
						for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
							if client.name == "rust_analyzer" then
								local success, err = pcall(function()
									vim.lsp.buf.execute_command({ command = "rust-analyzer.reloadWorkspace" })
									vim.lsp.buf.execute_command({
										command = "rust-analyzer.runSingle",
										arguments = { { uri = vim.uri_from_bufnr(bufnr), range = nil } },
									})
								end)
								if success then
									vim.notify("Rust-analyzer synced", vim.log.levels.INFO)
								else
									vim.notify("Rust-analyzer sync failed: " .. tostring(err), vim.log.levels.ERROR)
								end
							end
						end
					end)
				end,
			})

			-- Manual restart command
			vim.api.nvim_create_user_command("LspRustRestart", function()
				for _, client in pairs(vim.lsp.get_clients()) do
					if client.name == "rust_analyzer" then
						vim.cmd("LspRestart " .. client.id)
						vim.notify("Restarted rust-analyzer", vim.log.levels.INFO)
						break
					end
				end
			end, { desc = "Restart rust-analyzer manually" })
		end,
	},
}
