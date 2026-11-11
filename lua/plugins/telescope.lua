return {
  { "nvim-telescope/telescope.nvim", branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make",
        cond = function() return vim.fn.executable("make") == 1 end },
    },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Symbols" },
      { "<leader>gC", function() require("telescope.builtin").git_commits() end, desc = "Git commits" },
      { "<leader>gB", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
    },
    config = function()
      require("telescope").setup({})
      pcall(require("telescope").load_extension, "fzf")
    end },
}
