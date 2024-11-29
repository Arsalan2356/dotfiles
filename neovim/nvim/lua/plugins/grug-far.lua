return {
  "MagicDuck/grug-far.nvim",
  config = function()
    local grug = require("grug-far")
    grug.setup({})
    vim.keymap.set("v", ",g", grug.open)
  end,
  keys = {
    {
      ",g",
      "<cmd>GrugFar<cr>",
      desc = "Open Grug and search",
    },
  },
}
