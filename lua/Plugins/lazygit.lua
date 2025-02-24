-- ~/.config/nvim/lua/plugins/lazygit.lua
return {
	"kdheepak/lazygit.nvim",
	-- Optional dependency for better floating window support
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- Lazy-load the plugin when these commands are called
	cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter" },
	-- Keybindings
	keys = {
		-- Open LazyGit for the whole repo
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit (Repo)" },
		-- Open LazyGit filtered to current file
		{ "<leader>lf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit (Current File)" },
		-- Open LazyGit config
		{ "<leader>lc", "<cmd>LazyGitConfig<cr>", desc = "LazyGit Config" },
		-- Filter commits by current branch
		{ "<leader>lb", "<cmd>LazyGitFilter<cr>", desc = "LazyGit (Branch Commits)" },
	},
	-- Configuration options
	config = function()
		-- Customize LazyGit behavior
		vim.g.lazygit_floating_window_winblend = 0 -- Transparency (0 = opaque, 100 = fully transparent)
		vim.g.lazygit_floating_window_scaling_factor = 0.9 -- Window size (0.9 = 90% of Neovim window)
		vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- Border style
		vim.g.lazygit_floating_window_use_plenary = 1 -- Use plenary.nvim for floating window (1 = yes)
		vim.g.lazygit_use_neovim_remote = 1 -- Use nvr for Git commits if available (1 = yes)

		-- Optional: Override LazyGit command if needed
		-- vim.g.lazygit_command = "lazygit" -- Default, change if your binary has a different name
	end,
}
