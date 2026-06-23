return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,

        opts = {
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },

            dashboard = {
                enabled = true,
                preset = {
                    header = [[
▓█████▄  ▒█████   ███▄ ▄███▓ ██▓ ███▄    █  ██▓ ▒█████   ███▄    █ ▓█████▄ ▓█████ ██▒   █▓
▒██▀ ██▌▒██▒  ██▒▓██▒▀█▀ ██▒▓██▒ ██ ▀█   █ ▓██▒▒██▒  ██▒ ██ ▀█   █ ▒██▀ ██▌▓█   ▀▓██░   █▒
░██   █▌▒██░  ██▒▓██    ▓██░▒██▒▓██  ▀█ ██▒▒██▒▒██░  ██▒▓██  ▀█ ██▒░██   █▌▒███   ▓██  █▒░
░▓█▄   ▌▒██   ██░▒██    ▒██ ░██░▓██▒  ▐▌██▒░██░▒██   ██░▓██▒  ▐▌██▒░▓█▄   ▌▒▓█  ▄  ▒██ █░░
░▒████▓ ░ ████▓▒░▒██▒   ░██▒░██░▒██░   ▓██░░██░░ ████▓▒░▒██░   ▓██░░▒████▓ ░▒████▒  ▒▀█░
 ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒░   ░  ░░▓  ░ ▒░   ▒ ▒ ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ▒▒▓  ▒ ░░ ▒░ ░  ░ ▐░
 ░ ░  ░ ░ ░ ░ ▒  ░      ░    ▒ ░   ░   ░ ░  ▒ ░░ ░ ░ ▒     ░   ░ ░  ░ ░  ░    ░       ░░
   ░        ░ ░         ░    ░           ░  ░      ░ ░           ░    ░       ░  ░     ░
                    ]],
                },
            },

            picker = {
                enabled = true,
                layout = {
                    preset = "ivy",
                },

                sources = {
                    explorer = {
                        hidden = true,
                    },
                },
            },

            gh = { enabled = true },
            git = { enabled = true },
            debug = { enabled = true },
            scratch = { enabled = true },

            explorer = {
                enabled = true,
                replace_netrw = true,
                follow_file = true,
                auto_close = false,
            },

            input = { enabled = true },
            scope = { enabled = true },
            indent = { enabled = true },
            words = { enabled = true },
            scroll = { enabled = true },
            animate = { enabled = true },
            terminal = { enabled = true },
            lazygit = { enabled = true },
            rename = { enabled = true },
            image = { enabled = true },
            zen = { enabled = true },
        },
    },

}
