return {
    "hrsh7th/nvim-cmp",  -- Completion plugin
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",  -- LSP completion source
        "hrsh7th/cmp-buffer",  -- Buffer completion
        "hrsh7th/cmp-path",  -- Path completion
        "hrsh7th/cmp-cmdline"  -- Command-line completion
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(), -- Show completion menu
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" }
            })
        })
    end
}
 
