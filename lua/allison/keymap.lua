vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function nmap(map, fn, desc)
	vim.keymap.set("n", map, fn, { desc = desc })
end

local function xmap(map, fn, desc)
	vim.keymap.set("x", map, fn, { desc = desc })
end

xmap("J", ":m '>+1<CR>gv=gv", "Move Selection down")
xmap("K", ":m '<-2<CR>gv=gv", "Move Selection up")

nmap("U", "<C-r>", "Redo")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
nmap("<leader>Y", [["+Y]], "Copy to clipboard until end of line")

vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from clipboard" })
nmap("<leader>P", [["+P]], "Paste from clipboard before cursor")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
})
