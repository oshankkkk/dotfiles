local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clone lazy.nvim if not already installed
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end

vim.opt.rtp:prepend(lazypath)
--Tell lazy.nvim to look inside 'lua/plugins' for plugin specs
require("lazy").setup("plugins")

