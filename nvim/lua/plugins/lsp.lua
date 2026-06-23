-- ==================== LSP CONFIG ====================

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "windwp/nvim-autopairs"
        },
        config = function()
            -- ====================== CMP ======================
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
                sorting = { priority_weight = 2 },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                experimental = { ghost_text = true },
                formatting = {
                    format = function(_, vim_item)
                        local icons = {
                            Text          = "󰉿",
                            Method        = "󰆧",
                            Function      = "󰊕",
                            Constructor   = "",
                            Field         = "󰜢",
                            Variable      = "󰀫",
                            Class         = "󰠱",
                            Interface     = "",
                            Module        = "󰏗",
                            Property      = "󰜢",
                            Unit          = "󰑭",
                            Value         = "󰎠",
                            Enum          = "",
                            Keyword       = "󰌋",
                            Snippet       = "",
                            Color         = "󰏘",
                            File          = "󰈙",
                            Reference     = "󰈇",
                            Folder        = "󰉋",
                            EnumMember    = "",
                            Constant      = "󰏿",
                            Struct        = "󰙅",
                            Event         = "",
                            Operator      = "󰆕",
                            TypeParameter = "󰊄",
                        }
                        vim_item.kind = (icons[vim_item.kind] or "") .. " " .. vim_item.kind
                        return vim_item
                    end,
                },
            })
            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )

            -- ====================== Capabilities & on_attach ======================
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local function on_attach(client, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = bufnr,
                        silent = true,
                        desc = desc,
                    })
                end

                -- ====================== LSP navigation ======================
                map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                map("n", "K", vim.lsp.buf.hover, "Hover docs")
                map("n", "<leader>k", vim.lsp.buf.signature_help, "Signature help")

                -- ====================== Actions ======================
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

                -- ====================== Workspace ======================
                map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
                map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
                map("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "List workspace folders")

                -- ====================== Semantic tokens control ======================
                if client.server_capabilities.semanticTokensProvider then
                    local ft = vim.bo[bufnr].filetype
                    local keep = { "rust", "go" }
                    local allowed = false
                    for _, v in ipairs(keep) do
                        if v == ft then
                            allowed = true
                            break
                        end
                    end
                    if not allowed then
                        client.server_capabilities.semanticTokensProvider = nil
                    end
                end
            end

            -- ====================== LSP Configurations ======================
            -- Python: ty (definitions/types) + ruff (linting/formatting)
            vim.lsp.config("ty", {
                cmd = { "ty", "server" },
                filetypes = { "python" },
                root_markers = { "pyproject.toml", "uv.lock", ".git" },
                single_file_support = true,
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("ty")

            vim.lsp.config("ruff", {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    client.server_capabilities.hoverProvider = false
                    on_attach(client, bufnr)
                end,
                init_options = {
                    settings = {
                        lineLength = 100,
                    },
                },
            })
            vim.lsp.enable("ruff")

            -- Lua
            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                }
            })
            vim.lsp.enable("lua_ls")

            -- TypeScript / JavaScript
            vim.lsp.config("ts_ls", {
                cmd = { "typescript-language-server", "--stdio" },
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("ts_ls")

            -- Rust
            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
                on_attach = on_attach,
                -- settings
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = { command = "clippy" },
                    },
                },
            })
            vim.lsp.enable("rust_analyzer")

            -- Go
            vim.lsp.config("gopls", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("gopls")

            -- Zig
            -- vim.lsp.config("zls", {
            --    capabilities = capabilities,
            --    on_attach = on_attach,
            --})
            --vim.lsp.enable('zls')

            -- Toml
            vim.lsp.config("taplo", {
                capabilities = capabilities,
                on_attach = on_attach
            })
            vim.lsp.enable("taplo")

            -- YAML
            vim.lsp.config("yamlls", {
                cmd = { "yaml-language-server", "--stdio" },
                capabilities = capabilities,
                on_attach = on_attach,
                -- settings
                settings = {
                    yaml = {
                        validate = true,
                        schemaStore = { enable = true },
                    },
                },
            })
            vim.lsp.enable("yamlls")

            -- Markdown
            vim.lsp.config("marksman", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("marksman")
        end,
    },
}
