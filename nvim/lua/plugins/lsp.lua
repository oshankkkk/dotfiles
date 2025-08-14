return {
  {
    "williamboman/mason.nvim",
    lazy = false, -- Load at startup
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
    },

    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls","ts_ls", "jdtls",  "html",
    "cssls",
    "tailwindcss","gopls"},
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
require("lspconfig").gopls.setup({
root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})
-- Java
lspconfig.jdtls.setup({
        capabilities = capabilities,
  cmd = { "jdtls" },  -- Mason installs it in PATH, so this works
  root_dir = lspconfig.util.root_pattern(".git", "pom.xml", "build.gradle"),  -- auto-detects project root
})
--js and ts
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  root_dir = function(fname)
    local util = require("lspconfig.util")
    -- Don't attach if it's a Deno project
    if util.root_pattern("deno.json", "deno.jsonc")(fname) then
      return nil
    end
    -- Attach if tsconfig, package.json, or .git found
    return util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
  end,
  single_file_support = false, -- only attach in a real project
  init_options = {
    preferences = {
      includeCompletionsWithSnippetText = true,
      includeCompletionsForImportStatements = true,
    },
  },
})
--LSP key maps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          opts.desc = "Show LSP references"
          vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

          opts.desc = "Go to declaration"
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

          opts.desc = "Show LSP definitions"
          vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

          opts.desc = "Show LSP implementations"
          vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

          opts.desc = "Show LSP type definitions"
          vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

          opts.desc = "See available code actions"
          vim.keymap.set({ "n", "v" }, "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

          opts.desc = "Smart rename"
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          opts.desc = "Show buffer diagnostics"
          vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

          opts.desc = "Show line diagnostics"
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

          opts.desc = "Show documentation for what is under cursor"
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          opts.desc = "Restart LSP"
          vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
{
  "nvimtools/none-ls.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.golangci_lint.with({
          command = vim.fn.stdpath("data") .. "/mason/bin/golangci-lint",
          args = { "run", "--out-format", "json", "$FILENAME" },
        }),
      },
    })

    require("mason-null-ls").setup({
      ensure_installed = { "golangci-lint" },
      automatic_installation = true,
    })
  end,
}
,
}

