return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true

      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        
        -- VS Code doesn't typically dim inactive windows
        dim_inactive = {
            enabled = false,
        },

        styles = {
            comments = { "italic" },
            conditionals = {},
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },

        color_overrides = {
            mocha = {
                base = "#1e1e2e",    -- Original dark background
                mantle = "#181825",  -- Original sidebar
                crust = "#11111b",   -- Original status bar
                
                -- "Just a little bit brighter"
                text = "#dae1fa",
            },
        },

        -- Tweak UI elements to look like VS Code (No Bold)
        custom_highlights = function(colors)
            return {
                -- VS Code Line Numbers are a specific grey
                LineNr = { fg = "#7f849c" }, 
                
                -- Current Line: Brighter color, but standard weight (NO BOLD)
                CursorLineNr = { fg = colors.lavender },
                
                -- VS Code selection color is subtle
                Visual = { bg = "#45475a", style = {} },
                
                -- Vertical split line
                WinSeparator = { fg = "#313244", bg = "NONE" },
                
                -- Autocompletion popup
                Pmenu = { bg = "#181825", fg = colors.text },
                PmenuSel = { bg = "#45475a", fg = "NONE" },
            }
        end,

        integrations = {
          treesitter = true,
          native_lsp = {
             enabled = true,
             virtual_text = {
                 errors = { "italic" },
                 hints = { "italic" },
                 warnings = { "italic" },
                 information = { "italic" },
             },
             underlines = {
                 errors = { "undercurl" },
                 hints = { "undercurl" },
                 warnings = { "undercurl" },
                 information = { "undercurl" },
             },
          },
          lsp_trouble = true,
          cmp = true,
          gitsigns = true,
          telescope = true,
          mason = true,
          rainbow_delimiters = true,
          neotree = true,

          -- [[ LUALINE INTEGRATION START ]]
          -- This tells Catppuccin to override the default lualine colors
          lualine = {
              enabled = true,
              -- This function receives the palette (C) and applies your custom logic
              all = function(C)
                  -- Since you have transparent_background = true above, we use "NONE"
                  local transparent_bg = "NONE" 

                  return {
                      normal = {
                          a = { bg = C.blue, fg = C.mantle, gui = "bold" },
                          b = { bg = C.surface0, fg = C.blue },
                          c = { bg = transparent_bg, fg = C.text },
                      },
                      insert = {
                          a = { bg = C.green, fg = C.base, gui = "bold" },
                          b = { bg = C.surface0, fg = C.green },
                      },
                      terminal = {
                          a = { bg = C.green, fg = C.base, gui = "bold" },
                          b = { bg = C.surface0, fg = C.green },
                      },
                      command = {
                          a = { bg = C.peach, fg = C.base, gui = "bold" },
                          b = { bg = C.surface0, fg = C.peach },
                      },
                      visual = {
                          a = { bg = C.mauve, fg = C.base, gui = "bold" },
                          b = { bg = C.surface0, fg = C.mauve },
                      },
                      replace = {
                          a = { bg = C.red, fg = C.base, gui = "bold" },
                          b = { bg = C.surface0, fg = C.red },
                      },
                      inactive = {
                          a = { bg = transparent_bg, fg = C.blue },
                          b = { bg = transparent_bg, fg = C.surface1, gui = "bold" },
                          c = { bg = transparent_bg, fg = C.overlay0 },
                      },
                  }
              end,
          },
          -- [[ LUALINE INTEGRATION END ]]
        },
      })
      
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
