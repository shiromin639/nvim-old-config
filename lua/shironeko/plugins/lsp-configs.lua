return {
  -- 1. THE VENV DETECTOR (Detects your 'uv' environments automatically)
  {
    "tnfru/nvim-venv-detector",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("venv_detector").setup()
    end,
  },

  -- 2. THE LSP CONFIG
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/lazydev.nvim", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local keymap = vim.keymap

      require("mason").setup()
      
      -- Common Capabilities (Autocomplete)
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Common Keymaps (The "LspAttach" event)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          opts.desc = "Show LSP references"
          keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
          
          opts.desc = "Go to declaration"
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          
          opts.desc = "Show LSP definition"
          keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          
          opts.desc = "Go to implementation"
          keymap.set("n", "gi", "<cmd>ClangdSwitchSourceHeader<cr>", opts)

          opts.desc = "See available code actions"
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          
          opts.desc = "Smart rename"
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          
          opts.desc = "Show line diagnostics"
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
          
          opts.desc = "Show documentation"
          keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end,
      })

      -- Configure Servers via Mason Handlers
      mason_lspconfig.setup({
        -- Added 'ruff' to the list as we discussed earlier
        ensure_installed = { "gopls", "basedpyright", "ts_ls", "ruff" },
        
        handlers = {
          -- Default handler
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Specific config for gopls
          ["gopls"] = function()
            lspconfig.gopls.setup({
              capabilities = capabilities,
              settings = {
                gopls = {
                  completeUnimported = true,
                  usePlaceholders = true,
                  analyses = { unusedparams = true },
                  staticcheck = true,
                  buildFlags = {"-tags=with_tla"},
                },
              },
            })
          end,

          -- Specific config for pyright
          ["basedpyright"] = function()
            lspconfig.pyright.setup({
              capabilities = capabilities,
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = "basic",
                  },
                },
              },
            })
          end,

          -- Specific config for ruff
          ["ruff"] = function()
            lspconfig.ruff.setup({
              capabilities = capabilities,
              on_attach = function(client, _)
                client.server_capabilities.hoverProvider = false
              end,
            })
          end,
        },
      }) 

      -- Diagnostic Signs and Virtual Text
      local severity = vim.diagnostic.severity
      vim.diagnostic.config({
        virtual_text = { source = "always", prefix = "●" },
        underline = true,
        update_in_insert = false,
        signs = {
          text = {
            [severity.ERROR] = " ",
            [severity.WARN] = " ",
            [severity.HINT] = "󰠠 ",
            [severity.INFO] = " ",
          },
        },
      })
      
      -- AUTO-FORMATTING SECTION
      local format_group = vim.api.nvim_create_augroup("LspFormatting", {})

      -- 1. Auto-Format/Organize for Go
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        group = format_group,
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = {only = {"source.organizeImports"}}
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({async = false})
        end
      })

      -- 2. Auto-Format for Python (using Ruff)
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        group = format_group,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
}
