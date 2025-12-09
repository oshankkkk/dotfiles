return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",  -- Harpoon v2 (latest)
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local harpoon = require("harpoon")

    --harpoon:setup() -- Optional config if you want customization later
  end,
}

