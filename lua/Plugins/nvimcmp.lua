return {
	{ "L3MON4D3/LuaSnip", dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" } },
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline" },
		config = function()
			local cmp = require("cmp")
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			require("luasnip.loaders.from_vscode").lazy_load()
			ls.add_snippets("cpp", {
				s("endl", { t("endl") }),
			}, { key = "cpp" })
			ls.filetype_extend("cpp", { "cpp" })
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif ls.expand_or_jumpable() then
							ls.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif ls.jumpable(-1) then
							ls.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources(
					{ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" } },
					{ { name = "buffer" } }
				),
				formatting = {
					format = function(entry, vim_item)
						if entry.source.name == "nvim_lsp" then
							vim_item.abbr = vim_item.abbr:match("^[^%(%[]+") or vim_item.abbr
						end
						return vim_item
					end,
				},
			})
			vim.notify("CMP and snippets configured", vim.log.levels.INFO)
		end,
	},
}
