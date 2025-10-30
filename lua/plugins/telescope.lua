return {
  {
    "nvim-telescope/telescope.nvim",
    priority = 1000,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    opts = {},
    keys = function()
      local builtin = require("telescope.builtin")

      return {
        {
          ";f",
          function()
            builtin.find_files({ no_ignore = false, hidden = true })
          end,
          desc = "Find files (respects .gitignore)",
        },
        {
          ";r",
          builtin.live_grep,
          desc = "Live grep in cwd",
        },
        {
          "\\\\",
          builtin.buffers,
          desc = "List open buffers",
        },
        {
          ";;",
          builtin.resume,
          desc = "Resume previous picker",
        },
        {
          ";e",
          builtin.diagnostics,
          desc = "Diagnostics for open buffers",
        },
        {
          ";s",
          builtin.treesitter,
          desc = "Treesitter symbols",
        },
        {
          "sf",
          function()
            local telescope = require("telescope")
            local function telescope_buffer_dir()
              return vim.fn.expand("%:p:h")
            end
            telescope.extensions.file_browser.file_browser({
              path = "%:p:h",
              cwd = telescope_buffer_dir(),
              respect_gitignore = false,
              hidden = true,
              grouped = true,
              previewer = false,
              initial_mode = "normal",
              layout_config = { height = 40 },
            })
          end,
          desc = "Open File Browser at buffer path",
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      -- FIX: provide fallback {} if opts.defaults is nil
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          n = {},
        },
      })

      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = { preview_cutoff = 9999 },
        },
      }

      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          mappings = {
            n = {
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["<C-u>"] = function(prompt_bufnr)
                for _ = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for _ = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
            },
          },
        },
      }

      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
    end,
  },
}
