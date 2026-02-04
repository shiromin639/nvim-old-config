return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- ⬅️ THIS IS CRITICAL. Do not use "main"
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    fold = { enable = true },
    ensure_installed = {
      "c", "cpp", "lua", "go", "gomod", "gowork", 
      "python", "bash", "json", "vim", "query", "java",
    },
  },

  config = function(_, opts)
    -- This module ONLY exists in the 'master' branch
    require("nvim-treesitter.configs").setup(opts)
  end,
}
