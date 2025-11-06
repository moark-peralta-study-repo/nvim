return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local util = require("lspconfig.util")

      -- === on_attach: set LSP keymaps per buffer ===
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- LSP actions
        vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = bufnr })
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "References", buffer = bufnr })
        vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "Hover Info", buffer = bufnr })
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
        vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "Code Rename", buffer = bufnr })
        vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "Code Goto Declaration", buffer = bufnr })
        vim.keymap.set(
          "n",
          "<leader>ci",
          require("telescope.builtin").lsp_implementations,
          { desc = "Code Implementation", buffer = bufnr }
        )

        -- Diagnostics
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1 })
        end, { desc = "Previous Diagnostic", buffer = bufnr })
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1 })
        end, { desc = "Next Diagnostic", buffer = bufnr })
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics List", buffer = bufnr })
      end

      -- === CSS LSP ===
      opts.servers.cssls = vim.tbl_deep_extend("force", opts.servers.cssls or {}, {
        capabilities = capabilities,
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
        on_attach = on_attach,
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
        on_attach = on_attach,
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
        on_attach = on_attach,
      })

      opts.servers.tsserver = nil

      -- Disable default tsserver setup if you plan to use a separate TypeScript plugin
      opts.setup.tsserver = function(_, server_opts)
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
                "clsx\\(([^)]*)\\)",
                "cva\\(([^)]*)\\)",
                "tw`([^`]*)`",
              },
            },
          },
        },
        on_attach = on_attach,
      })

      vim.g.get_lsp_capabilities = capabilities
    end,

    init = function()
      vim.lsp.handlers["$/progress"] = function() end
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
      handlers = {
        jdtls = function() end,
      },
    },
  },

  {
    "mfussenegger/nvim-jdtls",
  },
}
