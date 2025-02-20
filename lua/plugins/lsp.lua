return {
	"neovim/nvim-lspconfig",
	event = "VimEnter",
	config = function()
		local nvim_lsp = require("lspconfig")
        local capabilities = require('blink.cmp').get_lsp_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		local lsp = {
			pylsp = {
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = {
								ignore = { "W391" },
								maxLineLength = 100,
							},
						},
					},
				},
			},
			lua_ls = {
				cmd = { "lua-lsp" },
				capabilities = capabilities,
				single_file_support = true,
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {

						runtime = {
							version = "Lua 5.1",
						},
						workspace = {
							library = {
								vim.fn.expand("~/.luarocks/share/lua/5.1"),
								vim.env.VIMRUNTIME,
							},
						},
						hint = {
							enable = true,
							setTtype = true,
							arrayIndex = "Disable",
						},
						diagnostics = {
							globals = { "vim", "use", "winid" },
							disable = { "undefined-field", "undefined-doc-name" },
						},
						completion = {
							enable = true,
							callSnippet = "Both",
						},
						telemetry = {
							enable = false,
						},
					})
				end,

				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
			
		}

		for key, value in pairs(lsp) do
			nvim_lsp[key].setup(value)
		end

		-- keymap
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				map("gd", require("telescope.builtin").lsp_definitions, "[G]OTO [D]EFINITION")
				map("gD", vim.lsp.buf.declaration, "[G]OTO [D]ECLARATION")
				map("gr", require("telescope.builtin").lsp_references, "[G]OTO [R]EFErences")
				map("gi", require("telescope.builtin").lsp_implementations, "[G]OTO [I]MPLEMENTATION")
				map("gt", require("telescope.builtin").lsp_type_definitions, "[G]OTO TYPE [D]EFINITION")
				map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[L]SP [s]YMBOLS")
				map(
					"<leader>lS",
					require("telescope.builtin").lsp_dynamic_workspace_symbols,
					"[L]SP WORKSPACE [S]YMBOLS"
				)
				map("<leader>lr", vim.lsp.buf.rename, "[L]SP [R]ENAME")
				map("<leader>la", vim.lsp.buf.code_action, "[L]SP CODE [A]CTION", { "n", "x" })
			end,
		})
	end,
}
