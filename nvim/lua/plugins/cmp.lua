return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "windwp/nvim-autopairs",
            "milanglacier/minuet-ai.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<CR>"] = function(fallback)
                        if cmp.visible() then
                            cmp.abort()
                        end
                        fallback()
                    end,
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        elseif require("luasnip").expand_or_locally_jumpable() then
                            require("luasnip").expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if require("luasnip").locally_jumpable(-1) then
                            require("luasnip").jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-c>"] = cmp.mapping.abort(),
                    ["<Esc>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.abort()
                        else
                            fallback()
                        end
                    end),
                }),

                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip",  priority = 750 },
                    { name = "minuet",   priority = 400 },
                    { name = "buffer",   priority = 250 },
                    { name = "path",     priority = 200 },
                }),

                sorting = { priority_weight = 2 },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                experimental = {
                    ghost_text = {
                        hl_group = "Comment",
                    },
                },
                preselect = cmp.PreselectMode.None,

                formatting = {
                    format = function(_, vim_item)
                        local icons = {
                            Text = "󰉿",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "󰏗",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "󰊄",
                        }

                        vim_item.kind = (icons[vim_item.kind] or "") .. " " .. vim_item.kind
                        return vim_item
                    end,
                },
            })

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
}
