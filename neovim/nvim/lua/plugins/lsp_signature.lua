return {
  "ray-x/lsp_signature.nvim",
  config = function()
    local sig = require("lsp_signature")
    sig.setup({
      hint_enable = false,
    })
    vim.keymap.set(
      { "n" },
      "<leader>k",
      vim.lsp.buf.signature_help,
      { silent = true, noremap = true, desc = "Show Function Signature" }
    )
  end,
}
