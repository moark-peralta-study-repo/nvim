return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    priority = 1000,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        hijack_netrw_behavior = "disabled",
      },
    },
    init = function()
      -- Prevent LazyVim from opening a floating preview
      pcall(vim.api.nvim_del_augroup_by_name, "LazyVimAutostartNeoTree")

      -- Safely open Neo-tree in sidebar on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          require("neo-tree.command").execute({
            action = "show",
            source = "filesystem",
            position = "left",
            reveal = true,
          })
        end,
      })
    end,
  },
}
