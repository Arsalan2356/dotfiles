return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },

    { "nvim-telescope/telescope-ui-select.nvim" },
    { "jvgrootveld/telescope-zoxide" },
    { "nvim-rhstree/nvim-web-devicons",         enabled = vim.g.have_nerd_font },
  },
  config = function()
    local z_utils = require("telescope._extensions.zoxide.utils")
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
        ["zoxide"] = {
          prompt_title = "[ Zoxide ]",
          mappings = {
            default = {
              after_action = function(selection)
                print("Update to (" .. selection.z_score .. ")" .. selection.path)
              end,
            },
            ["<C-s>"] = {
              action = function(selection)
                vim.cmd.edit(selection.path)
              end,
            },
            ["<C-q>"] = { action = z_utils.create_basic_command("split") },
          },
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "zoxide")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[S]earch [/] in Open Files" })

    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim files" })

    vim.keymap.set("n", "<leader>sa", function()
      builtin.find_files({
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
        search_dirs = { "/home/rc", "G:/Rnd/Coding Stuff" },
      })
    end, { desc = "[S]earch [A]ll Files" })

    vim.keymap.set(
      "n",
      "<leader>cd",
      require("telescope").extensions.zoxide.list,
      { desc = "[S]earch [F]iles with [Z]oxide" }
    )
    vim.keymap.set("n", "<leader>p", builtin.commands, { desc = "Open Command Palette" })
  end,
}
