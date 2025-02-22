return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "leoluz/nvim-dap-go",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Initialize dap-ui
            dapui.setup()
            require("dap-go").setup()

            -- Auto open/close UI when debugging starts/stops
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Ensure keybindings are applied properly
            local opts = { noremap = true, silent = true, desc = "DAP: " }

            vim.keymap.set("n", "<Leader>dt", function()
                dap.toggle_breakpoint()
                print("🔴 Breakpoint Set")
            end, { desc = "Toggle Breakpoint" })

            vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue Debugging" })
            vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
            vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Open Debug Console" })
        end,
    }
}
