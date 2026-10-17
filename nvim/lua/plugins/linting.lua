return {
  {
    "dense-analysis/ale",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local g = vim.g

      -- Keep ALE limited to the linters already configured for this setup.
      g.ale_linters_explicit = 1
      g.ale_linters = {
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },

        lua = { "selene" },

        markdown = { "markdownlint_cli2" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = {},
      }

      -- Use eslint_d as the executable for ALE's ESLint linter.
      g.ale_javascript_eslint_executable = "eslint_d"
      g.ale_typescript_eslint_executable = "eslint_d"

      -- Match the previous lint timing: on save and when leaving insert mode.
      g.ale_lint_on_enter = 0
      g.ale_lint_on_text_changed = "never"
      g.ale_lint_on_insert_leave = 1
      g.ale_lint_on_save = 1

      g.ale_root = {
        eslint = {
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.json",
          "package.json",
        },
        selene = {
          "selene.toml",
          "selene.yml",
          "selene.yaml",
        },
        markdownlint = {
          ".markdownlint.json",
          ".markdownlint.jsonc",
          ".markdownlint.yaml",
          ".markdownlint.yml",
          ".markdownlint-cli2.jsonc",
          ".markdownlint-cli2.yaml",
        },
      }
    end,
  },
}
