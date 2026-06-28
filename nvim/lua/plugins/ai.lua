return {
    {
        "milanglacier/minuet-ai.nvim",
        event        = "InsertEnter",
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        opts         = {
            provider = "openai_fim_compatible",

            provider_options = {
                openai_fim_compatible = {
                    api_key = "TERM",
                    name = "Ollama",
                    end_point = "http://127.0.0.1:11434/v1/completions",
                    model = "qwen3-coder-next",

                    optional = {
                        max_tokens = 256,
                        temperature = 0,
                        top_p = 0.9,
                    },
                },
            },
            virtualtext = {
                auto_trigger_ft = {},
            }
        },
    }
}
