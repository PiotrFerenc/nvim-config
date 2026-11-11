local netcoredbg = vim.fn.expand("~/.local/share/netcoredbg/netcoredbg")

local function dap_fn(name, ...)
  local args = { ... }
  return function() require("dap")[name](unpack(args)) end
end

return {
  { "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", tag = "v4.0.0", dependencies = { "nvim-neotest/nvim-nio" } },
    },
    keys = {
      { "<F5>", dap_fn("continue"), desc = "Debug continue/start" },
      { "<F9>", dap_fn("toggle_breakpoint"), desc = "Toggle breakpoint" },
      { "<F10>", dap_fn("step_over"), desc = "Step over" },
      { "<F11>", dap_fn("step_into"), desc = "Step into" },
      { "<S-F11>", dap_fn("step_out"), desc = "Step out" },
      { "<leader>b", dap_fn("toggle_breakpoint"), desc = "Toggle breakpoint" },
      { "<leader>B", function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end, desc = "Conditional breakpoint" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug UI" },
      { "<leader>dx", dap_fn("terminate"), desc = "Debug stop" },
      { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Eval" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

      dap.adapters.coreclr = function(callback)
        if vim.fn.executable(netcoredbg) ~= 1 then
          vim.notify("netcoredbg nie znaleziony: " .. netcoredbg, vim.log.levels.ERROR)
          return
        end
        callback({ type = "executable", command = netcoredbg, args = { "--interpreter=vscode" } })
      end

      local function find_dll()
        local cwd = vim.fn.getcwd()
        local name = vim.fn.fnamemodify(cwd, ":t")
        local guess = vim.fn.glob(cwd .. "/bin/Debug/*/" .. name .. ".dll")
        local path = vim.fn.input("Path to dll: ", guess ~= "" and guess or (cwd .. "/bin/Debug/"), "file")
        return path ~= "" and path or dap.ABORT
      end

      dap.configurations.cs = {
        { type = "coreclr", name = "Launch (netcoredbg)", request = "launch",
          program = function()
            vim.notify("dotnet build...")
            local out = vim.fn.system({ "dotnet", "build" })
            if vim.v.shell_error ~= 0 then
              vim.notify("dotnet build nie powiódł się:\n" .. out, vim.log.levels.ERROR)
              return dap.ABORT
            end
            return find_dll()
          end },
        { type = "coreclr", name = "Attach", request = "attach",
          processId = require("dap.utils").pick_process },
      }
    end },
}
