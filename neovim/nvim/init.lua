local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "<Tab>"
vim.g.have_nerd_font = true
vim.opt.termguicolors = true

require("lazy").setup("plugins", {
  dev = {
    path = "~/.local/share/nvim/nix",
    fallback = false,
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "C",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "K",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
require("rc")
