return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                use_libuv_file_watcher = true, -- Enable real-time file watching
                filtered_items = {
                    visible = false,   -- Show hidden files permanently
                    hide_dotfiles = false, -- Show dotfiles (e.g., .gitignore, .env)
                    hide_gitignored = false, -- Show Git-ignored files
                    never_show = { ".git" }
                },
            },
        })

        -- Toggle Neo-tree visibility
        vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })
        -- Explicitly close Neo-tree
        vim.keymap.set('n', '<C-x>', ':Neotree close<CR>', { noremap = true, silent = true })
    end
}
