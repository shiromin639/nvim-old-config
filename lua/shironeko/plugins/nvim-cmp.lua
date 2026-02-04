return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine (Required for LSP, even if you don't use snippets directly)
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
    },
    -- Completion Sources
    'hrsh7th/cmp-nvim-lsp', -- "Library" (LSP)
    'hrsh7th/cmp-buffer',   -- "Buffer" (Text in current file)
    'hrsh7th/cmp-path',     -- Filesystem paths
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    luasnip.config.setup {}

    -- Minimal set of icons for clarity
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
          luasnip.lsp_expand(args.body) -- Required for LSP function expansion
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
      },
      -- Mappings: Minimal + Tab Navigation
      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm { select = true }, -- Enter to confirm

        -- TAB MAPPING
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item() -- Select next if menu is open
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump() -- Jump to next arg if inside a function snippet
          else
            fallback() -- Normal Tab behavior
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

      -- Sources: Prioritized Library (LSP) -> Buffer -> Path
      sources = {
        { name = 'nvim_lsp', max_item_count = 8 },
        { name = 'buffer', max_item_count = 8 },
        { name = 'path', max_item_count = 8 },
        { name = 'gopls'},
      },

      -- Formatting: Icons + Source Name
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
      },
    }
  end,
}
