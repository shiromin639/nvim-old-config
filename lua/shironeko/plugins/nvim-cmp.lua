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

      -- 1. THIS IS THE FIX: Auto-select the first item
      completion = {
        -- "noinsert": Selects the item but doesn't insert text until you press Enter
        -- If you see "noselect" here, delete it! That is what stops the coloring.
        completeopt = "menu,menuone,noinsert",
      },

      -- 2. Window Settings
      window = {
        completion = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          col_offset = -3,
          side_padding = 0,
          scrollbar = true,
        },
        documentation = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          max_width = 80,
          max_height = 20,
        },
      },

      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        
        -- "select = true" means "Accept currently selected item"
        -- Since we forced selection above, this now works instantly.
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
        { name = 'nvim_lsp', max_item_count = 50 },
        { name = 'luasnip', max_item_count = 5 },
        { name = 'path', max_item_count = 5 },
        { name = 'buffer', max_item_count = 5 },
      },

      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format(" %s ", kind_icons[vim_item.kind]) 
          
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
