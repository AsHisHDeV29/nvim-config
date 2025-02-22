return {
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		-- Setup null-ls with formatting sources
		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- Rust
				null_ls.builtins.formatting.rustfmt,

				-- Go
				null_ls.builtins.formatting.gofmt,
				null_ls.builtins.formatting.goimports,

				-- C/C++
				null_ls.builtins.formatting.clang_format,
			},
			-- Debug mode to troubleshoot
			debug = true, -- Keep true for now, set to false later
			-- Ensure null-ls attaches to buffers and supports formatting
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					print("null-ls attached to buffer " .. bufnr .. " with formatting support")
				end
				if client.supports_method("textDocument/rangeFormatting") then
					print("null-ls supports range formatting for buffer " .. bufnr)
				end
			end,
		})

		-- Function to format the entire buffer
		local function format_buffer()
			if not next(vim.lsp.get_active_clients({ bufnr = 0 })) then
				print("No LSP client attached to format")
				return
			end
			local success, err = pcall(function()
				vim.lsp.buf.format({ async = false })
			end)
			if not success then
				print("Full buffer formatting failed: " .. err)
			end
		end

		-- Function for scope (range) formatting
		local function format_range()
			if not next(vim.lsp.get_active_clients({ bufnr = 0 })) then
				print("No LSP client attached for range formatting")
				return
			end
			local start_pos = vim.api.nvim_buf_get_mark(0, "<") -- Start of visual selection
			local end_pos = vim.api.nvim_buf_get_mark(0, ">") -- End of visual selection
			local success, err = pcall(function()
				vim.lsp.buf.format({
					range = {
						start = { start_pos[1], start_pos[2] },
						["end"] = { end_pos[1], end_pos[2] },
					},
					async = false,
				})
			end)
			if not success then
				print("Range formatting failed: " .. err)
			end
		end

		-- Format on save (VS Code-like)
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("NullLsAutoFormat", { clear = true }),
			pattern = { "*.lua", "*.rs", "*.go", "*.c", "*.cpp", "*.h", "*.hpp" },
			callback = function()
				print("BufWritePre triggered") -- Debug
				format_buffer()
			end,
			desc = "Format buffer before saving",
		})

		-- Keybinding for scope formatting in visual mode (VS Code-like)
		vim.keymap.set("v", "<leader>f", function()
			print("Range format triggered") -- Debug
			format_range()
		end, { desc = "Format selected range" })

		-- Manual full-buffer formatting keymap (optional)
		vim.keymap.set("n", "<leader>gf", function()
			print("Manual full format triggered") -- Debug
			vim.lsp.buf.format({ async = true })
		end, { desc = "Format entire buffer manually" })
	end,
}
