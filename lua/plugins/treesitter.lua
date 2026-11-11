return {
  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSInstallInfo" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c_sharp", "lua", "vim", "vimdoc", "json", "xml", "yaml", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end },
}
