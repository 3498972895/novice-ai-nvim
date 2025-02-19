return {
	"stevearc/conform.nvim",
	event = { "BufReadPre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = false, lsp_format = "fallback" })
			end,
			mode = "n",
			desc = "LSP: LSP FORMAT BUFFER",
		},
	},
	opts = {
		notify_on_error = true,
		format_on_save = function(bufnr)
			local disable_filetypes = {}
			local lsp_format_opt
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			return {
				timeout_ms = 300,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			python = { "black" },
            lua = { "stylua" }
		},
		formatters = {
		},
	},
}
