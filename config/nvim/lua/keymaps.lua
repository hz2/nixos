local map = vim.keymap.set

-- window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- better indent in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- move lines up/down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor centered on search
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- don't yank on paste in visual
map("v", "p", '"_dP')

-- clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- explicit format (leader f) — no format on save
map({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",   { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",     { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",   { desc = "Help" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",    { desc = "Recent files" })

-- LSP (set up per-buffer in plugins.lua on_attach)
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev,          { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next,          { desc = "Next diagnostic" })
