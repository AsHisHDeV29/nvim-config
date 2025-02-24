return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
		config = function()
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node
			require("luasnip.loaders.from_vscode").lazy_load()

			ls.add_snippets("cpp", { s("endl", { t("endl") }) }, { key = "cpp" })
			ls.filetype_extend("cpp", { "cpp" })
			ls.add_snippets("javascript", {
				s("clg", { t("console.log("), i(1), t(")") }),
				s("func", {
					t("function "),
					i(1, "name"),
					t("("),
					i(2, "params"),
					t(") {"),
					t({ "", "\t" }),
					i(0),
					t({ "", "}" }),
				}),
			}, { key = "javascript" })
			ls.add_snippets("typescript", {
				s("clg", { t("console.log("), i(1), t(")") }),
				s("tfunc", {
					t("const "),
					i(1, "name"),
					t(": ("),
					i(2, "params"),
					t(") => "),
					i(3, "ReturnType"),
					t(" = ("),
					i(4, "args"),
					t(") => {"),
					t({ "", "\t" }),
					i(0),
					t({ "", "}" }),
				}),
			}, { key = "typescript" })
			ls.filetype_extend("javascript", { "javascript" })
			ls.filetype_extend("typescript", { "javascript", "typescript" })
			ls.add_snippets("python", {
				s("pdb", { t("import pdb; pdb.set_trace()") }),
				s("main", { t({ "def main():", "\t" }), i(1), t({ "", 'if __name__ == "__main__":', "\tmain()" }) }),
			}, { key = "python" })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline" },
		config = function()
			local cmp = require("cmp")
			local ls = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
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
					-- Added for suggestion selection
					["<Up>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i" }),
					["<Down>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i" }),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000, keyword_length = 1 },
					{ name = "luasnip", priority = 750, keyword_length = 2 },
					{ name = "buffer", priority = 500, keyword_length = 3 },
					{ name = "path", priority = 250 },
				}),
				completion = { completeopt = "menu,menuone,noinsert", autocomplete = { "TextChanged" } },
				window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
			})
			vim.notify("CMP and snippets configured", vim.log.levels.INFO)
		end,
	},
}
