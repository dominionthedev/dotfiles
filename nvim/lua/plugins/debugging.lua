return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "theHamsta/nvim-dap-virtual-text"
        },

        keys = {
            { "<F5>",       function() require("dap").continue() end,          desc = "Continue" },
            { "<F6>",       function() require("dap").restart() end,           desc = "Restart" },
            { "<F10>",      function() require("dap").step_over() end,         desc = "Step Over" },
            { "<F11>",      function() require("dap").step_into() end,         desc = "Step Into" },
            { "<F12>",      function() require("dap").step_out() end,          desc = "Step Out" },

            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },

            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Condition: "))
                end,
                desc = "Conditional breakpoint",
            },

            {
                "<leader>dl",
                function()
                    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: "))
                end,
                desc = "Log point",
            },

            {
                "<leader>dc",
                function()
                    require("dap").run_to_cursor()
                end,
                desc = "Run to cursor",
            },

            {
                "<leader>dr",
                function()
                    require("dap").repl.toggle()
                end,
                desc = "REPL",
            },

            {
                "<leader>dx",
                function()
                    require("dap").terminate()
                end,
                desc = "Terminate",
            },

            {
                "<leader>dd",
                function()
                    require("dap").disconnect()
                end,
                desc = "Disconnect",
            },
        },

        config = function()
            vim.fn.sign_define("DapBreakpoint", {
                text = "",
                texthl = "DiagnosticError",
            })

            vim.fn.sign_define("DapBreakpointCondition", {
                text = "",
                texthl = "DiagnosticWarn",
            })

            vim.fn.sign_define("DapLogPoint", {
                text = "",
                texthl = "DiagnosticInfo",
            })

            vim.fn.sign_define("DapStopped", {
                text = "󰁕",
                texthl = "DiagnosticHint",
                linehl = "Visual",
            })
        end,
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
            {
                "<leader>de",
                function()
                    require("dapui").eval()
                end,
                desc = "Eval"
            }
        },

        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup({
                layouts = {
                    {
                        position = "left",
                        size = 45,
                        elements = {
                            "scopes",
                            "stacks",
                            "breakpoints",
                            "watches",
                        },
                    },
                    {
                        position = "bottom",
                        size = 12,
                        elements = {
                            "repl",
                            "console",
                        },
                    },
                },

                floating = {
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },

                controls = {
                    enabled = true,
                },
            })

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

    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {},
        keys = {
            {
                "<leader>dgt",
                function()
                    require("dap-go").debug_test()
                end,
                desc = "Debug nearest Go test",
                ft = "go",
            },
            {
                "<leader>dgl",
                function()
                    require("dap-go").debug_last_test()
                end,
                desc = "Debug last Go test",
                ft = "go",
            },
        },
    },


    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("dap-python").setup("debugpy-adapter")

            local dap = require("dap")
            vim.list_extend(dap.configurations.python, {
                {
                    type = "python",
                    request = "launch",
                    name = "Current file (.venv)",
                    program = "${file}",
                    pythonPath = function()
                        return vim.fn.getcwd() .. "/.venv/bin/python"
                    end,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Pytest current file (.venv)",
                    module = "pytest",
                    args = { "${file}" },
                    pythonPath = function()
                        return vim.fn.getcwd() .. "/.venv/bin/python"
                    end,
                },
            })
        end,
        keys = {
            {
                "<leader>dpt",
                function()
                    require("dap-python").test_method()
                end,
                desc = "Debug nearest Python test",
                ft = "python",
            },
            {
                "<leader>dpc",
                function()
                    require("dap-python").test_class()
                end,
                desc = "Debug Python test class",
                ft = "python",
            },
        },
    },
}
