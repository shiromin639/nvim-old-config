return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    indent = {
      char = '▏',
      -- We point this to our custom highlight group defined below
      highlight = "IblIndent", 
    },
    scope = {
      enabled = false, -- Keep this off so "current" doesn't light up
    },
    exclude = {
      filetypes = {
        'help', 'startify', 'dashboard', 'packer',
        'neogitstatus', 'NvimTree', 'Trouble',
      },
    },
  },
  config = function(_, opts)
    -- 1. Get the Catppuccin palette
    local hooks = require("ibl.hooks")
    -- If you want to hardcode the color, use "#45475a" (Surface1)
    -- If you want it slightly brighter, use "#585b70" (Surface2)
    local highlight_color = "#45475a" 

    -- 2. Create the highlight group with that specific grey
    vim.api.nvim_set_hl(0, "IblIndent", { fg = highlight_color })

    -- 3. Initialize the plugin
    require("ibl").setup(opts)
  end,
}
