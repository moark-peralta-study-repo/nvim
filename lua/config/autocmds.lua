-- vim.cmd([[
--   augroup jdtls_lsp
--     autocmd!
--     autocmd FileType java lua require("config.jdtls").setup_jdtls()
--   augroup end
-- ]])
--
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = "*.java",
  callback = function()
    require("config.jdtls").setup_jdtls()
  end,
})
