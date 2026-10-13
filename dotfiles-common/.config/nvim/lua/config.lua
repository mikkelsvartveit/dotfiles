-- Update buffer when embedded terminal has made changes
vim.api.nvim_create_autocmd({
	"BufEnter",
	"BufWinEnter",
}, {
	group = augroup,
	pattern = "*",
	callback = function()
		if vim.fn.filereadable(vim.fn.expand("%")) == 1 then
			vim.cmd("checktime")
		end
	end,
	desc = "Check for file changes on disk",
})

-- Make system clipboard work over SSH
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end

-- Copy current file name
vim.keymap.set("n", "<leader>yf", function()
	local path = vim.fn.expand("%:~:.")
	vim.fn.setreg("+", path)
	print("Copied to clipboard: " .. path)
end, { desc = "Copy file path" })

-- Copy current file name and line number
vim.keymap.set("n", "<leader>yy", function()
	local path = vim.fn.expand("%:~:.")
	local line = vim.fn.line(".")
	vim.fn.setreg("+", path .. ":" .. line)
	print("Copied to clipboard: " .. path .. ":" .. line)
end, { desc = "Copy file path with line number" })

-- Copy current file name and line selection
vim.keymap.set("v", "<leader>y", function()
	local path = vim.fn.expand("%:~:.")

	local first = vim.fn.line("v")
	local last = vim.fn.line(".")
	if first > last then
		first, last = last, first
	end
	local range = first == last and tostring(first) or (first .. "-" .. last)

	vim.fn.setreg("+", path .. ":" .. range)

	-- Exit visual mode and leave the cursor at the start of the selection, like `y`
	vim.cmd("normal! \x1b`<")

	print("Copied to clipboard: " .. path .. ":" .. range)
end, { desc = "Copy file path with line range" })
