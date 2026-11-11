vim.g.mapleader = " "
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.dotnet/tools") .. ":" .. vim.fn.expand("~/.dotnet")
vim.env.DOTNET_ROOT = vim.env.DOTNET_ROOT or vim.fn.expand("~/.dotnet")

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
o.clipboard = "unnamedplus"
o.cursorline = true
o.scrolloff = 8

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", tag = "v1.10.0", priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha", integrations = {
        cmp = true, gitsigns = true, nvimtree = true, telescope = { enabled = true },
        treesitter = true } })
      vim.cmd.colorscheme("catppuccin")
    end },

  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
      vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })
      vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git blame" })
      vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", { desc = "Git diff" })
    end },

  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c_sharp", "lua", "vim", "vimdoc", "json", "xml", "yaml", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end },

  { "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      { "L3MON4D3/LuaSnip", version = "v2.*" }, "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fb)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fb() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fb)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fb() end
          end, { "i", "s" }),
        }),
        sources = { { name = "nvim_lsp" }, { name = "nvim_lsp_signature_help" },
          { name = "luasnip" }, { name = "path" }, { name = "buffer" } },
      })
    end },

  { "neovim/nvim-lspconfig", tag = "v1.0.0",
    config = function()
      local caps = require("cmp_nvim_lsp").default_capabilities()
      require("lspconfig").csharp_ls.setup({ capabilities = caps })

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
          m("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
          m("]d", vim.diagnostic.goto_next, "Next diagnostic")
          m("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })
    end },

  { "nvim-telescope/telescope.nvim", branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local b = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", b.find_files, { desc = "Files" })
      vim.keymap.set("n", "<leader>fg", b.live_grep, { desc = "Grep" })
      vim.keymap.set("n", "<leader>fb", b.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fs", b.lsp_document_symbols, { desc = "Symbols" })
      vim.keymap.set("n", "<leader>gC", b.git_commits, { desc = "Git commits" })
      vim.keymap.set("n", "<leader>gB", b.git_branches, { desc = "Git branches" })
    end },

  { "nvim-tree/nvim-tree.lua", tag = "compat-nvim-0.9",
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<cr>", { desc = "File tree" })
    end },


  { "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", tag = "v4.0.0", dependencies = { "nvim-neotest/nvim-nio" } },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.expand("~/.local/share/netcoredbg/netcoredbg"),
        args = { "--interpreter=vscode" },
      }
      local function find_dll()
        local cwd = vim.fn.getcwd()
        local name = vim.fn.fnamemodify(cwd, ":t")
        local guess = vim.fn.glob(cwd .. "/bin/Debug/*/" .. name .. ".dll")
        return vim.fn.input("Path to dll: ", guess ~= "" and guess or (cwd .. "/bin/Debug/"), "file")
      end
      dap.configurations.cs = {
        { type = "coreclr", name = "Launch (netcoredbg)", request = "launch",
          program = function()
            vim.fn.system("dotnet build")
            return find_dll()
          end },
        { type = "coreclr", name = "Attach", request = "attach",
          processId = require("dap.utils").pick_process },
      }

      local k = function(l, f, d) vim.keymap.set("n", l, f, { desc = d }) end
      k("<F5>", dap.continue, "Debug continue/start")
      k("<F9>", dap.toggle_breakpoint, "Toggle breakpoint")
      k("<F10>", dap.step_over, "Step over")
      k("<F11>", dap.step_into, "Step into")
      k("<S-F11>", dap.step_out, "Step out")
      k("<leader>b", dap.toggle_breakpoint, "Toggle breakpoint")
      k("<leader>B", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, "Conditional breakpoint")
      k("<leader>du", dapui.toggle, "Debug UI")
      k("<leader>dx", dap.terminate, "Debug stop")
      vim.keymap.set({ "n", "v" }, "<leader>de", function() dapui.eval() end, { desc = "Eval" })
    end },

  { "stevearc/conform.nvim", tag = "v7.1.0",
    config = function()
      require("conform").setup({
        formatters_by_ft = { cs = { "csharpier" } },
        formatters = {
          csharpier = {
            command = vim.fn.expand("~/.dotnet/tools/csharpier"),
            args = { "format", "--write-stdout" },
            stdin = true,
          },
        },
        format_on_save = { timeout_ms = 3000, lsp_fallback = false },
      })
      vim.keymap.set("n", "<leader>f", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format" })
    end },

  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "catppuccin" } } },
  { "lewis6991/gitsigns.nvim", tag = "v0.9.0",
    config = function()
      local gs = require("gitsigns")
      gs.setup()
      vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next hunk" })
      vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
    end },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
})

-- dotnet build/run
vim.keymap.set("n", "<leader>db", "<cmd>!dotnet build<cr>", { desc = "dotnet build" })
vim.keymap.set("n", "<leader>dr", "<cmd>!dotnet run<cr>", { desc = "dotnet run" })
vim.keymap.set("n", "<leader>dt", "<cmd>!dotnet test<cr>", { desc = "dotnet test" })
