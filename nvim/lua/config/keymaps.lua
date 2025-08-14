-- Shortcut for setting keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local harpoon = require("harpoon")

-- Open netrw
keymap("n", "<leader>e", ":Ex<CR>", opts)

-- Open Telescope file finder
keymap("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, opts)

-- 'jk' to exit insert mode
keymap("i", "jk", "<Esc>", opts)


-- Add current file to Harpoon list
keymap("n", "<leader>a", function() harpoon:list():append() end)

-- Toggle Harpoon UI menu
keymap("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Quick nav to files
keymap("n", "<leader>1", function() harpoon:list():select(1) end)
keymap("n", "<leader>2", function() harpoon:list():select(2) end)
keymap("n", "<leader>3", function() harpoon:list():select(3) end)
keymap("n", "<leader>4", function() harpoon:list():select(4) end)


