return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    local kind_icons = {
      Text = '󰉿', Method = 'm', Function = '󰊕', Constructor = '',
      Field = '', Variable = '󰆧', Class = '󰌗', Interface = '',
      Module = '', Property = '', Unit = '', Value = '󰎠',
      Enum = '', Keyword = '󰌋', Snippet = '', Color = '󰏘',
      File = '󰈙', Reference = '', Folder = '󰉋', EnumMember = '',
      Constant = '󰇽', Struct = '', Event = '', Operator = '󰆕',
      TypeParameter = '󰊄',
    }

    cmp.setup {
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      
      -- 1. window: Enable BOTH windows (Completion + Documentation)
      window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          col_offset = -3,
          side_padding = 0,
          scrollbar = true,
        },
        -- This is the "Full Docs" window. It appears to the right of the list.
        documentation = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          max_width = 80, -- Allow the docs to be wide enough to read
          max_height = 20, -- Allow it to be tall enough
        },
      },

      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        
        -- 2. Scrolling the Documentation Window
        ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll Docs Up
        ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll Docs Down
        
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
          else fallback() end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
          else fallback() end
        end, { 'i', 's' }),
      },

      sources = {
        { name = 'nvim_lsp', max_item_count = 50 }, -- Enough for structs
        { name = 'luasnip', max_item_count = 5 },
        { name = 'path', max_item_count = 5 },
        { name = 'buffer', max_item_count = 5 },
      },

      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format(" %s ", kind_icons[vim_item.kind]) 
          
          -- 3. Keep the LIST narrow (so it doesn't float out)
          -- But this does NOT affect the documentation window width
          local max_width = 30 
          local label = vim_item.abbr
          local truncated_label = vim.fn.strcharpart(label, 0, max_width)
          if truncated_label ~= label then
            vim_item.abbr = truncated_label .. "…"
          end

          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            buffer = "[Buf]",
            path = "[Path]",
          })[entry.source.name]

          return vim_item
        end,
      },
    }
  end,
}
