return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp", -- Completion plugin
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer", -- Buffer completion
			"hrsh7th/cmp-path", -- Path completion
			"hrsh7th/cmp-cmdline", -- Command-line completion
		},
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Add custom snippet for endl
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			ls.add_snippets("cpp", {
				s("endl", {
					t("endl"), -- Inserts just "endl"
				}),
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif require("luasnip").expand_or_jumpable() then
							require("luasnip").expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif require("luasnip").jumpable(-1) then
							require("luasnip").jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- LSP source
					{ name = "luasnip" }, -- Snippet engine
					{ name = "path" }, -- Path completion
				}, {
					{ name = "buffer" }, -- Buffer words completion
				}),
				-- Added formatting to simplify LSP completions
				formatting = {
					format = function(entry, vim_item)
						if entry.source.name == "nvim_lsp" then
							vim_item.abbr = vim_item.abbr:match("^[^%(%[]+") or vim_item.abbr -- Strips params
						end
						return vim_item
					end,
				},
			})
		end,
	},
}
