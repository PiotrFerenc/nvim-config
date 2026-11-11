return {
  { "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gvdiffsplit", "Gdiffsplit", "Gblame" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git diff" },
    } },

  { "lewis6991/gitsigns.nvim", tag = "v0.9.0",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        -- mapowania tylko w buforach z repozytorium
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local m = function(k, f, d)
            vim.keymap.set("n", k, f, { buffer = bufnr, desc = d })
          end
          m("]h", gs.next_hunk, "Next hunk")
          m("[h", gs.prev_hunk, "Prev hunk")
          m("<leader>hp", gs.preview_hunk, "Preview hunk")
          m("<leader>hs", gs.stage_hunk, "Stage hunk")
          m("<leader>hr", gs.reset_hunk, "Reset hunk")
        end,
      })
    end },
}
