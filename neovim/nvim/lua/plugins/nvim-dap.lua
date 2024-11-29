return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    -- "williamboman/mason.nvim"
    -- "jay-babu/mason-nvim-dap.nvim"

    "leoluz/nvim-dap-go",
  },
  keys = function(_, keys)
    local dap = require("dap")
    local dapui = require("dapui")
    return {
      { '<F5>',      dap.continue,          desc = "Debug:Start/Continue" },
      { '<F1>',      dap.step_into,         desc = "Debug:Step Into" },
      { '<F2>',      dap.step_over,         desc = "Debug:Step Over" },
      { '<F3>',      dap.step_out,          desc = "Debug:Step Out" },
      { '<leader>b', dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition:"))
        end,
        desc = "Debug: Toggle Breakpoint"
      },

      { '<F7>',      dapui.toggle, desc = 'Debug: See last session result.' },
      { '<leader>E', dapui.eval,   desc = "Debug: Evaluate Statement" },

      unpack(keys),
    }
  end,
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup {
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = ""
        }
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" }
        }
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
      },
      layouts = { {
        elements = { {
          id = "scopes",
          size = 0.25
        }, {
          id = "breakpoints",
          size = 0.25
        }, {
          id = "stacks",
          size = 0.25
        }, {
          id = "watches",
          size = 0.25
        } },
        position = "left",
        size = 40
      }, {
        elements = { {
          id = "repl",
          size = 0.5
        }, {
          id = "console",
          size = 0.5
        } },
        position = "bottom",
        size = 10
      } },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
      },
      render = {
        indent = 1,
        max_value_lines = 100
      }
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    require("dap-go").setup {
      delve = {
        detached = false
      }
    }
  end,
}
