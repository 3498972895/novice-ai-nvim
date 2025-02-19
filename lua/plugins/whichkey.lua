local keys = {}
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "echasnovski/mini.icons", opts = {} },
	},
	opts = function()
		local mini_icons = require("mini.icons")
		return {
			preset = "helix",
			spec = {
				-- hidden group
				{ "<C-w>", hidden = true },
				{ "Y", hidden = true },
				{ "?", hidden = true },
				{ "<C-j>", hidden = true },
				{ "<C-k>", hidden = true },
				{ "<C-u>", hidden = true },
				{ "<C-d>", hidden = true },
				{ "<C-l>", hidden = true },
				{ "<C-n>", hidden = true },
				{ "<C-p>", hidden = true },
				{ "%", hidden = true },
				{ "<esc>", hidden = true },
				{ "\\", hidden = true },
				{ "|", hidden = true },
				{ "n", hidden = true },
				{ ">", hidden = true },
				{ "<", hidden = true },
				{ "f", hidden = true },
				{ "s", hidden = true },
				{ "q", hidden = true },
				{ "<C-Left>", hidden = true },
				{ "<C-Right>", hidden = true },
				{ "<C-Up>", hidden = true },
				{ "<C-Down>", hidden = true },
				{ "[%", hidden = true },
				{ "]%", hidden = true },
				{ "g", hidden = true },
				{ "F", hidden = true },
				{ "S", hidden = true },
				{ "T", hidden = true },
				{ "t", hidden = true },
				{ ",", hidden = true },
				{ ";", hidden = true },

				-- group naming

				{ "<leader>b", group = "[B]UFFER" },
				{ "<leader>f", group = "TELESCOPE [F]IND" },
				{ "<leader>l", group = "[L]SP KEYS" },
				{ "[d", desc = "PREV DIAGNOTIC" },
				{ "]d", desc = "NEXT DIAGNOTIC" },
				{ "<leader>", desc = "LEADER MAPPING" },
				{ "<C-space>", desc = "BLINK TRIGGER" },
				{ "K", desc = "LSP HOVER" },
				{ "<leader>c", desc = "[C]ODECOMPANION" },
			},
			icons = {
				mappings = false,
			},
			plugins = {
				spelling = {
					enabled = false,
				},
				presets = {
					operators = false,
					motions = false,
					windows = false,
					text_objects = false,
					windows = false,
					nav = false,
					z = false,
					g = false,
				},
			},
			triggers = {
				{ "<leader>", mode = { "n" } },
				{ "[", mode = { "n" } },
				{ "]", mode = { "n" } },
				{ "g", mode = { "n" } },
			},
		}
	end,
	keys = {},
}
