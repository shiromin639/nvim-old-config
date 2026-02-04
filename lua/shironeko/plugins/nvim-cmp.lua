return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },
    'saadparwaiz1/cmp_luasnip',

    -- Core Completion Sources
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    luasnip.config.setup {}

    -- Professional Icon Set
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
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm { select = true },

        -- Tab for both Menu Navigation and Snippet Jumping
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },

      -- "Unbloated" Source List: Limited to 8 items each
      sources = {
        { name = 'nvim_lsp', max_item_count = 8 }, -- Covers C/C++, Go, etc.
        { name = 'luasnip',  max_item_count = 5 },
        { name = 'buffer',   max_item_count = 5 },
        { name = 'path',     max_item_count = 5 },
      },

      -- UI: Icons + Clean Source Labels
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip  = '[Snip]',
            buffer   = '[Buf]',
            path     = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
