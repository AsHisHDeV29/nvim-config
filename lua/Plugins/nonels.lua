return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.clang_format,
				},
				debug = true, -- Set to false once stable
				on_attach = function(client, bufnr)
					if not vim.bo[bufnr].modifiable then
						return
					end
				end,
			})

			local original_notify = vim.notify
			vim.notify = function(msg, log_level)
				if msg:match("null-ls") and (not log_level or log_level <= vim.log.levels.INFO) then
					return
				end
				original_notify(msg, log_level)
			end

			local function format_buffer()
				local bufnr = vim.api.nvim_get_current_buf()
				if not vim.bo[bufnr].modifiable then
					return
				end
				if not next(vim.lsp.get_clients({ bufnr = bufnr })) then
					return
				end
				vim.lsp.buf.format({ async = false })
			end

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("NullLsAutoFormat", { clear = true }),
				pattern = { "*.lua", "*.rs", "*.go", "*.c", "*.cpp", "*.h", "*.hpp" },
				callback = function()
					format_buffer()
				end,
				desc = "Format buffer before saving",
			})

			vim.keymap.set("n", "<leader>gf", format_buffer, { desc = "Format entire buffer manually" })
		end,
	},
}
