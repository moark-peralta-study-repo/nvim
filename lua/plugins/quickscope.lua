return {
  "unblevable/quick-scope",
  event = "BufReadPost",
  config = function()
    vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
    vim.cmd([[
        augroup qs_colors
          autocmd!
          autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
          autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
        augroup END
      ]])
    vim.g.qs_lazy_highlight = 1
  end,
}
