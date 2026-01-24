return {
  -- ==========================================
  -- 🎨 THEMES & UI (Pywal Support)
  -- ==========================================
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "neopywal",
    },
  },

  { "folke/alpha-nvim", enabled = false },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- ==========================================
  -- 🔧 EDITOR TOOLS
  -- ==========================================

  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
    enabled = false,
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- ==========================================
  -- 🤖 AI CODING ASSISTANT (Avante)
  -- ==========================================
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "openai",
      auto_suggestions_provider = "openai",
      openai = {
        endpoint = "https://litellm.sph-prod.ethz.ch/v1",
        model = "anthropic/claude-3-5-sonnet",
        temperature = 0,
        max_tokens = 4096,
      },
    },
    config = function(_, opts)
      local key = os.getenv("SPH_API_KEY")

      if not key then
        vim.notify("SPH_API_KEY not found in environment!", vim.log.levels.WARN)
      else
        vim.env.OPENAI_API_KEY = key
      end

      require("avante").setup(opts)
    end,
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },

  -- ==========================================
  -- 🧠 CODING & PARSING
  -- ==========================================

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(".git", "*.iml", "mvnw", "gradlew", "pom.xml", "build.gradle")(
              fname
            ) or vim.fn.getcwd()
          end,
        },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "java",
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
      })
    end,
  },
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
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- LSPs
        "astro-language-server",
        "clangd",
        "pyright",
        "jdtls",
        "dockerfile-language-server",
        "yaml-language-server",
        "rust-analyzer",

        -- Formatters
        "prettier",
        "stylua",
        "clang-format",
        "black",
        "shfmt",

        -- Linters
        "shellcheck",
        "eslint_d",
        "markdownlint",
        "hadolint",
        "codelldb",
      })
    end,
  },
}
