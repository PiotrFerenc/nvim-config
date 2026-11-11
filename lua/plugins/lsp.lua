-- vim.diagnostic.jump istnieje od 0.11; na 0.10 użyj goto_next/goto_prev
local function diag_jump(count)
  return function()
    if vim.diagnostic.jump then
      vim.diagnostic.jump({ count = count, float = true })
    elseif count > 0 then
      vim.diagnostic.goto_next()
    else
      vim.diagnostic.goto_prev()
    end
  end
end

return {
  { "neovim/nvim-lspconfig", tag = "v1.0.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()

      if vim.fn.executable("csharp-ls") == 1 then
        require("lspconfig").csharp_ls.setup({ capabilities = caps })
      else
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "cs", once = true,
          callback = function()
            vim.notify("csharp-ls nie jest w PATH (dotnet tool install -g csharp-ls)", vim.log.levels.WARN)
          end,
        })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local m = function(k, f, d) vim.keymap.set("n", k, f, { buffer = ev.buf, desc = d }) end
          m("gd", vim.lsp.buf.definition, "Definition")
          m("gD", vim.lsp.buf.declaration, "Declaration")
          m("gi", vim.lsp.buf.implementation, "Implementation")
          m("gr", vim.lsp.buf.references, "References")
          m("K", vim.lsp.buf.hover, "Hover")
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature help" })
          m("<leader>rn", vim.lsp.buf.rename, "Rename")
          m("<leader>ca", vim.lsp.buf.code_action, "Code action")
          m("[d", diag_jump(-1), "Prev diagnostic")
          m("]d", diag_jump(1), "Next diagnostic")
          m("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })
    end },
}
