return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<F5>",
                function() require("dap").continue() end,
                desc = "Start/Continue debugging",
            },
            {
                "<F10>",
                function() require("dap").step_over() end,
                desc = "Step over",
            },
            {
                "<F11>",
                function() require("dap").step_into() end,
                desc = "Step into",
            },
            {
                "<F12>",
                function() require("dap").step_out() end,
                desc = "Step out",
            },
            {
                "<leader>db",
                function() require("dap").toggle_breakpoint() end,
                desc = "Toggle breakpoint",
            },
            {
                "<leader>dr",
                function() require("dap").repl.open() end,
                desc = "Open REPL",
            },
        },
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "Toggle DAP UI",
            },
        },

        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()

            dap.listeners.after.event_initialized["dapui"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui"] = function()
                dapui.close()
            end
        end,
    },
}
