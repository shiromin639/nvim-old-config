return {
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }, -- Only load for C/C++ files
  config = function()
    local clangd_ext = require("clangd_extensions")

    clangd_ext.setup({
      ast = {
        -- These are unicode, should be available in any font
        role_icons = {
          type = "🄣",
          declaration = "🄓",
          expression = "🄔",
          statement = ";",
          specifier = "🄢",
          ["template argument"] = "🆃",
        },
        kind_icons = {
          Compound = "🄲",
          Recovery = "🅁",
          TranslationUnit = "🅄",
          PackExpansion = "🄿",
          TemplateTypeParm = "🅃",
          TemplateTemplateParm = "🅃",
          TemplateParamObject = "🅃",
        },
        highlights = {
          detail = "Comment",
        },
      },
      memory_usage = {
        border = "none",
      },
      symbol_info = {
        border = "none",
      },
    })

    -- KEYMAPS
    local keymap = vim.keymap
    
    -- This solves your "not an editor command" issue
    keymap.set("n", "gs", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "Switch between Header/Source" })
    
    -- Optional: View symbol info under cursor (memory layout, etc.)
    keymap.set("n", "<leader>cs", "<cmd>ClangdSymbolInfo<CR>", { desc = "Clangd Symbol Info" })
  end,
}
