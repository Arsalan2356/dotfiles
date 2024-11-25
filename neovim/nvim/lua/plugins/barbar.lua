return {
	"romgrk/barbar.nvim",
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {},
	config = function()
		local barbar = require("barbar")
		barbar.setup({
			insert_at_end = true,
		})
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { desc = "Buffer: " .. desc })
		end
		map(",,", "<Cmd>BufferPrevious<CR>", "Go To Previous Buffer")
		map(",.", "<Cmd>BufferNext<CR>", "Go To Next Buffer")
		map(",<", "<Cmd>BufferMovePrevious<CR>", "Move Buffer to Previous")
		map(",>", "<Cmd>BufferMoveNext<CR>", "Move Buffer to Next")
		map(",bs", function()
			local count = vim.fn.input("Enter Buffer Number: ")
			return "<Cmd>BufferGoto " .. count
		end, "Go To Buffer Number")
		map(",c", "<Cmd>BufferPin<CR>", "Pin Buffer")
		map(",w", "<Cmd>BufferClose<CR>", "Close Buffer")
		map(",q", "<Cmd>BufferClose<CR>", "Close Buffer")
		map(",p", "<Cmd>BufferPick<CR>", "Pick Buffer")
		map(",bb", "<Cmd>BufferOrderByBufferNumber<CR>", "Sort By Number")
		map(",bn", "<Cmd>BufferOrderByBufferName<CR>", "Sort By Name")
		map(",bd", "<Cmd>BufferOrderByBufferDirectory<CR>", "Sort By Directory")
		map(",bl", "<Cmd>BufferOrderByBufferLanguage<CR>", "Sort By Language")
		map(",bw", "<Cmd>BufferOrderByBufferWindowNumber<CR>", "Sort By Window Number")
	end,
}
