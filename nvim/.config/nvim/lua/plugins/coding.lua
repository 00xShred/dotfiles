return {
  -- Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "c",
        "cpp",
        "astro",
        "css",
        "dockerfile",
        "toml",
        "rust",
        "ron",
        "latex",
        "scss",
        "svelte",
        "vue",
      })
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- Web Stack
      opts.formatters_by_ft.astro = { "prettier" }
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.typescript = { "prettier" }
      opts.formatters_by_ft.html = { "prettier" }
      opts.formatters_by_ft.css = { "prettier" }
      opts.formatters_by_ft.json = { "prettier" }
      opts.formatters_by_ft.markdown = { "prettier" }

      -- Systems Stack
      opts.formatters_by_ft.c = { "clang-format" }
      opts.formatters_by_ft.cpp = { "clang-format" }
      opts.formatters_by_ft.sh = { "shfmt" }
      opts.formatters_by_ft.rust = { "rustfmt" }

      -- Scripting
      opts.formatters_by_ft.lua = { "stylua" }
      opts.formatters_by_ft.python = { "black" }

      opts.format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == "rust" then
          return { timeout_ms = 2000, lsp_fallback = false }
        end
      end
    end,
  },
}
