return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
        },
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      local test
      require("mason-nvim-dap").setup({
        ensure_installed = { "java-test", "java-debug-adapter" },
        automatic_installation = true,
      })
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = vim.lsp.config
      local keymap = vim.keymap
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local function on_attach(client, bufnr)
        if client.server_capabilities.codeLensProvider then
          vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold", "BufWritePost" }, {
            buffer = bufnr,
            callback = function()
              vim.lsp.codelens.refresh()
            end,
          })
        end
      end

      lspconfig("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            codelens = {
              enable = true,
            },
          },
        },
      })

      -- lspconfig("ts_ls", {
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })

      --keymaps
      keymap.set("n", "<leader>dk", vim.lsp.buf.hover, { desc = "Code Hover Documentation" })

      keymap.set("n", "<leader>dd", vim.lsp.buf.hover, { desc = "Code Goto Definition" })

      keymap.set("n", "<leader>dr", require("telescope.builtin").lsp_references, { desc = "Code Goto References" })

      keymap.set({ "n", "v" }, "<leader>da", vim.lsp.buf.hover, { desc = "Code Actions" })

      keymap.set(
        "n",
        "<leader>di",
        require("telescope.builtin").lsp_implementations,
        { desc = "Code Goto Implentations" }
      )

      keymap.set("n", "<leader>dR", vim.lsp.buf.rename, { desc = "Code Rename" })
      vim.keymap.set("n", "<leader>dD", vim.lsp.buf.declaration, { desc = "Code Goto Declaration" })
    end,
  },
}
