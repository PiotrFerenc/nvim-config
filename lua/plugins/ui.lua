return {
  { "catppuccin/nvim", name = "catppuccin", tag = "v1.10.0", priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha", integrations = {
        cmp = true, gitsigns = true, nvimtree = true, telescope = { enabled = true },
        treesitter = true, which_key = true } })
      vim.cmd.colorscheme("catppuccin")
    end },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  { "nvim-lualine/lualine.nvim", event = "VeryLazy",
    opts = { options = { theme = "catppuccin" } } },

  { "folke/which-key.nvim", version = "^3.0.0", event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunk" },
        { "<leader>d", group = "debug / dotnet" },
        { "<leader>c", group = "code" },
      },
    } },

  { "nvim-tree/nvim-tree.lua", tag = "compat-nvim-0.9",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = { { "<leader>t", "<cmd>NvimTreeToggle<cr>", desc = "File tree" } },
    config = function() require("nvim-tree").setup() end },

  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
}
