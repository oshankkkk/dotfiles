-- Set <space> as leader key
vim.g.mapleader = " "
-- Load Lazy plugin manager
require("config.lazy")
require("config.keymaps")
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype ~= "" then return end  -- skip non-normal buffers

    local path = vim.fn.expand("%:p:h")
    if vim.fn.isdirectory(path) == 1 then
      vim.cmd("lcd " .. path)
    end
  end,
})

local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<CR>"] = function(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          local cmd = "kitty +kitten icat '" .. entry.path .. "'"
          vim.fn.system(cmd)
        end
      }
    }
  }
})

-- line numbers and make them relative
vim.opt.number=true
vim.opt.relativenumber=true
