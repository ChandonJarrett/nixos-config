local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

map("n", "<c-h>", "<c-w>h", { desc = "Move left" })
map("n", "<c-j>", "<c-w>j", { desc = "Move down" })
map("n", "<c-k>", "<c-w>k", { desc = "Move up" })
map("n", "<c-l>", "<c-w>l", { desc = "Move right" })

map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })

map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
