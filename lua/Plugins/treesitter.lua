return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate", -- Runs on install/update to keep parsers current
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			auto_install = true, -- Automatically installs parsers for opened filetypes
			highlight = { enable = true }, -- Enables syntax highlighting
			indent = { enable = true }, -- Enables Tree-sitter-based indentation
		})
	end,
}
