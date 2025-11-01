return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local util = require("lspconfig.util")

      -- === CSS LSP ===
      opts.servers.cssls = vim.tbl_deep_extend("force", opts.servers.cssls or {}, {
        capabilities = capabilities,
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      })

      -- === Lua LSP ===
      opts.servers.lua_ls = vim.tbl_deep_extend("force", opts.servers.lua_ls or {}, {
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            codeLens = { enable = true },
            completion = { callSnippet = "Replace" },
            hint = { enable = true },
          },
        },
        codelens = { enabled = true },
      })

      -- === TypeScript LSP ===
      opts.servers.tsserver = vim.tbl_deep_extend("force", opts.servers.tsserver or {}, {
        capabilities = capabilities,
        init_options = {
          hostInfo = "neovim",
          preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
        settings = {
          completions = { completeFunctionCalls = true },
        },
        root_dir = util.root_pattern("package.json", ".git"),
      })

      opts.setup.tsserver = function(_, server_opts)
        -- require("typescript").setup({ server = server_opts })
        return false
      end

      -- === TailwindCSS LSP ===
      opts.servers.tailwindcss = vim.tbl_deep_extend("force", opts.servers.tailwindcss or {}, {
        capabilities = capabilities,
        root_dir = util.root_pattern(
          "tailwind.config.cjs",
          "tailwind.config.js",
          "tailwind.config.ts",
          "postcss.config.js",
          "package.json",
          ".git"
        ),
        settings = {
          tailwindCSS = {
            validate = true,
            experimental = {
              classRegex = {
                -- Useful if you use clsx, cva, or custom utils
                "clsx\\(([^)]*)\\)",
                "cva\\(([^)]*)\\)",
                "tw`([^`]*)`",
              },
            },
          },
        },
      })

      vim.g.get_lsp_capabilities = capabilities
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
}
