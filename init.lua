vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim-tree zastępuje netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- narzędzia .NET w PATH (bez duplikatów)
local dotnet = vim.fn.expand("~/.dotnet")
for _, p in ipairs({ dotnet .. "/tools", dotnet }) do
  if not vim.env.PATH:find(p, 1, true) then
    vim.env.PATH = vim.env.PATH .. ":" .. p
  end
end
vim.env.DOTNET_ROOT = vim.env.DOTNET_ROOT or dotnet

require("config.options")
require("config.keymaps")
require("config.lazy")
