return {
  -- Mason + LSP
  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp", -- CMP for completion
      "hrsh7th/cmp-nvim-lsp", -- CMP LSP source
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      -- ------------------------------
      -- Mason setup
      -- ------------------------------
      require("mason").setup()

      -- ------------------------------
      -- CMP setup
      -- ------------------------------
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
        },
      })

      -- ------------------------------
      -- LSP capabilities from CMP
      -- ------------------------------
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ------------------------------
      -- on_attach function with keymaps
      -- ------------------------------
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>g", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      end

      -- ------------------------------
      -- Mason-LSPConfig setup
      -- This is the main part that's fixed
      -- ------------------------------
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      require("mason-lspconfig").setup({
        -- Ensure these servers are installed
        ensure_installed = { "gopls", "rust_analyzer", "jdtls" },

        -- Setup handlers for each server
        handlers = {
          -- Default handler for servers without custom config
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,

          -- Custom config for Go
          ["gopls"] = function()
            lspconfig.gopls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              root_dir = util.root_pattern("go.work", "go.mod", ".git"),
              settings = {
                gopls = {
                  analyses = { unusedparams = true },
                  staticcheck = true,
                },
              },
            })
          end,

          -- Custom config for Rust
          ["rust_analyzer"] = function()
            lspconfig.rust_analyzer.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                ["rust-analyzer"] = {
                  cargo = { allFeatures = true },
                  checkOnSave = { command = "clippy" },
                },
              },
            })
          end,

          -- Custom config for Java (using nvim-jdtls)
          ["jdtls"] = function()
            -- This is your original Java config, now correctly placed
            local jdtls = require("jdtls")
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

            local config = {
              cmd = { "jdtls", "-data", workspace_dir },
              root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
              on_attach = on_attach,
              capabilities = capabilities,
            }

            jdtls.start_or_attach(config)
          end,
        },
      })
    end,
  },
}
