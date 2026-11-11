-- dotnet build/run/test w terminalu (nie blokuje edytora, bez promptu ENTER)
local function term(cmd)
  return function()
    vim.cmd("botright 15split")
    vim.cmd("terminal " .. cmd)
    vim.cmd("startinsert")
  end
end

vim.keymap.set("n", "<leader>db", term("dotnet build"), { desc = "dotnet build" })
vim.keymap.set("n", "<leader>dr", term("dotnet run"), { desc = "dotnet run" })
vim.keymap.set("n", "<leader>dt", term("dotnet test"), { desc = "dotnet test" })
