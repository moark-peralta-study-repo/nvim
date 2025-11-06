return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
      local keymap = vim.keymap

      keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", { desc = "Git Preview Hunk" })
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      local keymap = vim.keymap
      keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git Blame" })
    end,
  },
}
