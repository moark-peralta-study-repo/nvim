local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--Paste without yanking text
keymap.set("v", "p", '"_dP')

keymap.set("n", "x", '"_X')

--Increment /Decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-a>")

--Delete word backward
keymap.set("n", "dw", "vb_d")

--Select all
keymap.set("n", "<leader>aa", "gg<S-v>G")

--Jumplist
keymap.set("n", "te", "tabedit", opts)

--Unsplitwindows
keymap.set("n", "<Leader>wu", ":only<CR>", opts)

--Move between buffers
for i = 1, 9 do
  keymap.set("n", "<leader>" .. i, ("<Cmd>BufferLineGoToBuffer %d<CR>"):format(i), { desc = "Go to buffer " .. i })
end

--Cycle through buffers
keymap.set("n", "<Tab>", ":bnext<CR>")
keymap.set("n", "<S-Tab>", ":bprevious<CR>")

--Close Buffers
keymap.set("n", "<leader>w", ":bdelete<CR>")

--nohlsearch
keymap.set("n", "<leader>n", ":nohlsearch<CR>")

--Toggle NeoTree
keymap.set("n", "<A-1>", function()
  require("neo-tree.command").execute({ toggle = true })
end, { desc = "Toggle Neo-tree[root dir]" })

--Tmux navigation-- Move Window
keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", opts)
keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", opts)
keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", opts)
keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", opts)

--Comments
keymap.set("n", "<leader>c", function()
  require("Comment.api").toggle.linewise.current()
end)
keymap.set("v", "<leader>c", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- Trouble.nvim for diagnostics (errors)
keymap.set("n", "<leader>xp", vim.diagnostic.goto_prev)
keymap.set("n", "<leader>xn", vim.diagnostic.goto_next)

-- Show Visual Lines
keymap.set("n", ";e", vim.diagnostic.open_float, { desc = "Toggle full diagnostics" })
