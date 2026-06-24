-- ==================== LSP CONFIG ====================

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- ====================== Capabilities =====================
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- ====================== on_attach ======================
            local function on_attach(client, bufnr)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = bufnr,
                        silent = true,
                        desc = desc,
                    })
                end

                -- navigation
                map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                map("n", "K", vim.lsp.buf.hover, "Hover docs")
                map("n", "<leader>k", vim.lsp.buf.signature_help, "Signature help")

                -- actions
                map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

                -- workspace
                map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
                map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
                map("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "List workspace folders")

                -- semantic tokens control
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

            -- ====================== LSP Servers ======================
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

            vim.lsp.config("ts_ls", {
                cmd = { "typescript-language-server", "--stdio" },
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("ts_ls")

            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = { command = "clippy" },
                    },
                },
            })
            vim.lsp.enable("rust_analyzer")

            vim.lsp.config("gopls", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("gopls")

            vim.lsp.config("taplo", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("taplo")

            vim.lsp.config("yamlls", {
                cmd = { "yaml-language-server", "--stdio" },
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    yaml = {
                        validate = true,
                        schemaStore = { enable = true },
                    },
                },
            })
            vim.lsp.enable("yamlls")

            vim.lsp.config("marksman", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("marksman")
        end,
    },
}
