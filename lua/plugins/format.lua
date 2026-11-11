local csharpier = vim.fn.expand("~/.dotnet/tools/csharpier")

return {
  { "stevearc/conform.nvim", tag = "v7.1.0",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function()
          require("conform").format({ async = true, lsp_fallback = false })
        end, desc = "Format" },
    },
    config = function()
      local have = vim.fn.executable(csharpier) == 1
      require("conform").setup({
        formatters_by_ft = have and { cs = { "csharpier" } } or {},
        formatters = {
          csharpier = {
            command = csharpier,
            args = { "format", "--write-stdout" },
            stdin = true,
          },
        },
        format_on_save = { timeout_ms = 3000, lsp_fallback = false },
      })
      if not have then
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "cs", once = true,
          callback = function()
            vim.notify("csharpier nie znaleziony (dotnet tool install -g csharpier) — formatowanie .cs wyłączone",
              vim.log.levels.WARN)
          end,
        })
      end
    end },
}
