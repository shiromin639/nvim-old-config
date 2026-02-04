vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = { noremap = true, silent = true }

-- Save file
keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save current file" })
keymap.set("i", "<C-s>", "<C-o>:w<cr>", { desc = "Save current file" })
-- Clear highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
vim.keymap.set('v', 'p', '"_dP', opts)

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement
-- Press Enter to add a line below
vim.keymap.set('n', '<CR>', 'o<Esc>', { desc = 'New line below' })
-- Press Shift+Enter to add a line above (Note: Shift+Enter can be tricky in some terminals)
--
-- Press Enter to add a line below
vim.keymap.set('n', '<CR>', 'o<Esc>', { desc = 'New line below' })
vim.keymap.set('n', '<S-CR>', 'O<Esc>', { desc = 'New line above' })

-- Press Shift+Enter to add a line above (Note: Shift+Enter can be tricky in some terminals)
--
vim.keymap.set('n', '<S-CR>', 'O<Esc>', { desc = 'New line above' })

vim.keymap.set("n", "<C-d>", "15<C-d>zz", { desc = "Scroll Down 15 lines" })
vim.keymap.set("n", "<C-u>", "15<C-u>zz", { desc = "Scroll Up 15 lines" })
-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>bd', ':bdelete!<CR>', opts)
-- Stay in indent mode 
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
-- Move lines in Normal mod
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)
-- Move lines in Insert mode (optional, but handy)
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
-- Move BLOCKS of lines in Visual mode (The most important fix)
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)
-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
