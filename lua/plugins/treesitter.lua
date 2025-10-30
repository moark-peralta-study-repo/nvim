return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
        "lua",
        "java",
        "javascript",
        "typescript",
        "tsx",
        "jsx",
        "html",
        "css",
        "json",
        "markdown",
        "markdown_inline",
        "gitignore",
        "http",
      },

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      autotag = {
        enable = true,
      },
    },
  },
}
