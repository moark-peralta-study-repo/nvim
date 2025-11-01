-- ~/.config/nvim/lua/plugins/lsp-config.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- === Lua LSP ===
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local tsserver = opts.servers.tsserver
      local lua_ls = opts.servers.lua_ls
      lua_ls = lua_ls or {}
      lua_ls.settings = vim.tbl_deep_extend("force", lua_ls.settings or {}, {
        Lua = {
          workspace = {
            checkThirdParty = false,
          },
          codeLens = {
            enable = true,
          },
          completion = {
            callSnippet = "Replace",
          },
          hint = {
            enable = true,
          },
        },
      })

      -- Enable codelens for Lua
      lua_ls.codelens = { enabled = true }
      lua_ls.capabilities = capabilities

      -- === TypeScript LSP ===
      tsserver = tsserver or {}
      tsserver.capabilities = capabilities

      tsserver.init_options = {
        hostInfo = "neovim",
        preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      }
      tsserver.settings = vim.tbl_deep_extend("force", tsserver.settings or {}, {
        completions = { completeFunctionCalls = true },
      })
      tsserver.root_dir = require("lspconfig.util").root_pattern("package.json", ".git")

      -- Optional: custom setup without breaking LazyVim defaults
      tsserver = function(_, server_opts)
        -- Example: integrate typescript.nvim
        -- require("typescript").setup({ server = server_opts })
        return false -- keep LazyVim default setup (codelens, inlay hints, etc.)
      end
    end,
  },
}
