return {
  -- Replaces blocking cmdline echo (which triggers "Press ENTER to continue"
  -- hit-enter prompts on long/multi-line messages, e.g. LSP errors) with
  -- async floating toasts that never steal focus.
  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    config = function()
      local notify = require "notify"
      notify.setup {
        stages = "fade",
        timeout = 3000,
        render = "compact",
        max_width = 60, -- cap toast width so a wall-of-text error doesn't fill the screen
      }

      -- Swallow repeats of the same message within a few seconds so a
      -- misbehaving LSP server (e.g. eslint erroring on every keystroke)
      -- doesn't stack a new toast on top of the last one.
      local last_msg, last_time
      vim.notify = function(msg, level, opts)
        local now = vim.uv.now()
        if msg == last_msg and last_time and (now - last_time) < 5000 then
          return
        end
        last_msg, last_time = msg, now
        return notify(msg, level, opts)
      end
    end,
  },

  -- Telescope: show .env and other gitignored/hidden files in find_files (<leader>ff)
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts = opts or {}

      -- 2. Keep your specific find_files overrides
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = vim.tbl_deep_extend("force", opts.pickers.find_files or {}, {
        -- hidden = true shows dotfiles, but .env is also gitignored (a file, not a
        -- dir), so fd was still skipping it under .gitignore rules. --no-ignore turns
        -- that off; --exclude below still prunes the heavy dirs, so it stays fast.
        hidden = true,
        no_ignore = true,
        find_command = { "fd", "--type", "f", "--hidden", "--no-ignore", "--strip-cwd-prefix",
          "--exclude", ".git",
          "--exclude", "node_modules",
          "--exclude", "build",
          "--exclude", "dist",
          "--exclude", ".next",
          "--exclude", "target",
        },
      })

      return opts
    end,
  },

  -- Override nvim-tree: show dotfiles / hidden folders
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        ignore = false, -- false = show gitignored files
      },
      filters = {
        dotfiles = false, -- false = show hidden files/folders (.git, .husky, etc.)
        custom = {},
        exclude = { "%.env", "%.env%.local", "%.env%." },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()

      -- Use modern Neovim 0.11+ API
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--offset-encoding=utf-16",
        },
        init_options = {
          fallbackFlags = {
            "-I/opt/homebrew/include",
          },
        },
        -- root_dir is vital for clangd to find the config.yaml or .git
        root_dir = vim.fs.root(0, { ".git", "compile_commands.json", "compile_flags.txt", ".clangd" }),
      })

      vim.lsp.enable "clangd"

      require "configs.lspconfig"
    end,
  },
  -- Diffview: load on command so DiffviewOpen is always available
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    config = function()
      -- Background-only diff highlights so treesitter syntax colors show through
      -- on added/changed lines. Diffview's windows remap DiffAdd->DiffviewDiffAdd
      -- etc. via winhl, so we must override THESE groups (not the base ones).
      local function set_diff_hl()
        vim.api.nvim_set_hl(0, "DiffviewDiffAdd",    { bg = "#16331f" }) -- added line: green tint
        vim.api.nvim_set_hl(0, "DiffviewDiffText",   { bg = "#2c5e3a" }) -- changed words: brighter green
        vim.api.nvim_set_hl(0, "DiffviewDiffChange", { bg = "#16331f" }) -- changed line: green tint
        vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = "#3a1618" }) -- deleted: red tint
      end

      require("diffview").setup({
        view = {
          default      = { layout = "diff2_horizontal", winbar_info = false },
          file_history = { layout = "diff2_horizontal", winbar_info = false },
        },
        enhanced_diff_hl = true,
        hooks = {
          diff_buf_win_enter = function(bufnr, _winid)
            -- attach treesitter after buffer is fully loaded in the window
            vim.api.nvim_buf_call(bufnr, function()
              if vim.bo[bufnr].filetype == "" then
                vim.cmd("filetype detect")
              end
              pcall(vim.treesitter.start, bufnr)
            end)
          end,
        },
      })

      set_diff_hl()
      -- Re-apply on theme change and every time a diff buffer is shown, so our
      -- colors always win over the base46 theme (which loads after startup).
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diff_hl })
      vim.api.nvim_create_autocmd("User", { pattern = "DiffviewDiffBufWinEnter", callback = set_diff_hl })
    end,
  },

  -- Neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    opts = {
      integrations = { diffview = true },
    },
  },
  -- DAP: Debugger for JS/TS/Node (loads only when a debug key is pressed)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "williamboman/mason.nvim",
        opts = {
          ensure_installed = { "js" }, -- installs js-debug-adapter (prebuilt, no build step)
          automatic_installation = true,
          handlers = {},               -- we configure adapters manually below
        },
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,          desc = "Debug: start / continue" },
      { "<leader>dn", function() require("dap").step_over() end,         desc = "Debug: step over" },
      { "<leader>di", function() require("dap").step_into() end,         desc = "Debug: step into" },
      { "<leader>do", function() require("dap").step_out() end,          desc = "Debug: step out" },
      { "<leader>dq", function() require("dap").terminate() end,         desc = "Debug: stop" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Debug: toggle UI" },
      { "<leader>dr", function() require("dap").repl.open() end,         desc = "Debug: open REPL" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: conditional breakpoint" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- js-debug adapter installed via mason (js-debug-adapter)
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      -- JS/TS debug configurations
      for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            console = "integratedTerminal",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process (--inspect)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Next.js: debug dev server",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "dev" },
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            sourceMaps = true,
            autoAttachChildProcesses = true, -- next dev forks the real server as a child process
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest test",
            runtimeExecutable = "node",
            runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest", "--runInBand" },
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- Auto open/close UI
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  -- Cursor smear/trail effect
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    config = function()
      require("smear_cursor").setup({})
    end,
  },

  {
    "andymass/vim-matchup",
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
      set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
      set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
      set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)
      set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end)
      set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end)
      set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end
  }
}
