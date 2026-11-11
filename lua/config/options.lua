local o = vim.opt

o.number = true
o.relativenumber = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.termguicolors = true
o.signcolumn = "yes"
o.ignorecase = true
o.smartcase = true
o.updatetime = 250
o.timeoutlen = 300
o.cursorline = true
o.scrolloff = 8
o.mouse = "a"
o.undofile = true
o.splitright = true
o.splitbelow = true

-- Schowek systemowy tylko gdy jest provider (inaczej start/rejestry zwalniają)
if vim.fn.executable("wl-copy") == 1 or vim.fn.executable("xclip") == 1 or vim.fn.executable("xsel") == 1 then
  o.clipboard = "unnamedplus"
end

-- Wcięcie 2 spacje dla formatów danych i Lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "json", "jsonc", "yaml", "xml", "html", "markdown" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})
