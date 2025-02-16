return {
    'nvim-lualine/lualine.nvim',
    dependency = {'nvim-tree/nvim-web-devicons'},
    config = function()
        require('lualine').setup({
            options = {
            theme = 'dracula'
           }
        })
    end
}
