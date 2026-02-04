return {
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
    mason_lspconfig.setup({
      ensure_installed = { "clangd", "gopls" },
    })

    -- 1. Common Capabilities (Autocomplete)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- 2. Common Keymaps (The "LspAttach" event)
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

    -- 3. Configure Servers via Mason Handlers
    -- This automatically loops through installed servers and sets them up
   require("mason").setup()

    -- MERGE setup and setup_handlers into one
    mason_lspconfig.setup({
      -- 1. List of servers to install
      ensure_installed = { "gopls" , "clangd"},
      
      -- 2. Define the handlers right here
      handlers = {
        -- The default handler (applies to every server not explicitly defined below)
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- Specific config for clangd
        ["clangd"] = function()
          lspconfig.clangd.setup({
            capabilities = capabilities,
            cmd = { "clangd", "--offset-encoding=utf-16", "--background-index" },
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
                analyses = { 
                  unusedparams = true,
                },
                staticcheck = true,
                buildFlags =  {"-tags=with_tla"},
              },
            },
          })
        end,
      },
    }) 
    -- 4. Diagnostic Signs
    local severity = vim.diagnostic.severity
    vim.diagnostic.config({
      signs = {
        text = {
          [severity.ERROR] = " ",
          [severity.WARN] = " ",
          [severity.HINT] = "󰠠 ",
          [severity.INFO] = " ",
        },
      },
    })
    
    -- 5. Auto-Organize Imports for Go (The "VS Code" experience)
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = {only = {"source.organizeImports"}}
        -- request code action synchronously
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
  end,
}
