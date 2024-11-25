return {
	"echasnovski/mini.nvim",
	config = function()
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })
		statusline.section_location = function()
			return "%2l:%-2v"
		end
		require("mini.move").setup({
			mappings = {
				left = "<C-Left>",
				right = "<C-Right>",
				up = "<C-Up>",
				down = "<C-Down>",
				line_left = "<C-Left>",
				line_right = "<C-Right>",
				line_up = "<C-Up>",
				line_down = "<C-Down>",
			},
		})
		require("mini.trailspace").setup({})
		vim.api.nvim_create_user_command("Trim", function()
			require("mini.trailspace").trim()
		end, {})
	end,
}
