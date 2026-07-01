return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },

        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local function buf_map(bufnr, mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, {
                    buffer = bufnr,
                    silent = true,
                    desc = desc,
                })
            end

            local function supports(client, method)
                return client:supports_method(method)
            end

            local semantic_keep = {
                rust = true,
                go = true,
            }

            local function setup_document_highlight(client, bufnr)
                if not supports(client, vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    return
                end

                local group = vim.api.nvim_create_augroup("dominion_lsp_highlight_" .. bufnr, { clear = true })

                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    group = group,
                    buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
                    group = group,
                    buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })
            end

            local function setup_inlay_hints(client, bufnr)
                if supports(client, vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end

            local function maybe_disable_semantic_tokens(client, bufnr)
                if not client.server_capabilities.semanticTokensProvider then
                    return
                end

                local ft = vim.bo[bufnr].filetype
                if not semantic_keep[ft] then
                    client.server_capabilities.semanticTokensProvider = nil
                end
            end

            local function on_attach(client, bufnr)
                maybe_disable_semantic_tokens(client, bufnr)
                setup_document_highlight(client, bufnr)
                setup_inlay_hints(client, bufnr)

                if client.name == "ruff" then
                    client.server_capabilities.hoverProvider = false
                end

                buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                buf_map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover docs")
                buf_map(bufnr, "n", "<leader>k", vim.lsp.buf.signature_help, "Signature help")

                buf_map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                buf_map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                buf_map(bufnr, "v", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                buf_map(bufnr, "n", "gT", vim.lsp.buf.type_definition, "Go to type definition")
                buf_map(bufnr, "n", "<leader>ci", function()
                    vim.lsp.buf.incoming_calls()
                end, "Incoming calls")
                buf_map(bufnr, "n", "<leader>co", function()
                    vim.lsp.buf.outgoing_calls()
                end, "Outgoing calls")

                if supports(client, vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    buf_map(bufnr, "n", "<leader>uh", function()
                        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                        vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
                    end, "Toggle inlay hints")
                end
            end

            -- Diagnostic display config lives in config/diagnostics.lua,
            -- loaded before this plugin. No need to re-call it here.

            vim.lsp.config("ty", {
                cmd = { "ty", "server" },
                filetypes = { "python" },
                root_markers = { "pyproject.toml", "uv.lock", "ruff.toml", ".git" },
                single_file_support = true,
                capabilities = capabilities,
                on_attach = on_attach,
            })
            vim.lsp.enable("ty")

            vim.lsp.config("ruff", {
                capabilities = capabilities,
                on_attach = on_attach,
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
                        runtime = {
                            version = "LuaJIT",
                        },
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        hint = {
                            enable = true,
                        },
                    },
                },
            })
            vim.lsp.enable("lua_ls")

            vim.lsp.config("ts_ls", {
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                },
                capabilities = capabilities,
                on_attach = on_attach,
                single_file_support = true,
            })
            vim.lsp.enable("ts_ls")

            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = true,
                        check = {
                            command = "clippy",
                        },
                        cargo = {
                            allFeatures = true,
                        },
                        procMacro = {
                            enable = true,
                        },
                        inlayHints = {
                            bindingModeHints = { enable = true },
                            closureReturnTypeHints = { enable = "always" },
                            discriminantHints = { enable = "fieldless" },
                            lifetimeElisionHints = {
                                enable = "skip_trivial",
                                useParameterNames = true,
                            },
                            typeHints = { enable = true },
                        },
                    },
                },
            })
            vim.lsp.enable("rust_analyzer")

            vim.lsp.config("gopls", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    gopls = {
                        gofumpt = true,
                        usePlaceholders = true,
                        staticcheck = true,
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
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
                        hover = true,
                        completion = true,
                        format = { enable = true },
                        schemaStore = {
                            enable = true,
                        },
                        keyOrdering = false,
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
