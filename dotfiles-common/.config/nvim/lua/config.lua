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
