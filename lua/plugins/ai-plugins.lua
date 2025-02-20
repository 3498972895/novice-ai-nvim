return {
	{

		"milanglacier/minuet-ai.nvim",
		dependencies = {
			{
				"Davidyz/VectorCode",
				version = "*",
				dependencies = { "nvim-lua/plenary.nvim" },
				cmd = "VectorCode",
				config = function()
					require("vectorcode").setup({
						-- number of retrieved documents
						n_query = 1,
					})
				end,
			},
		},
		config = function()
			local vectorcode_cacher = require("vectorcode.cacher")
			require("minuet").setup({
				prequest_timeout = 10,
				provider = "openai_fim_compatible",
				n_completions = 1, -- recommend for local model for resource saving
				-- I recommend beginning with a small context window size and incrementally
				-- expanding it, depending on your local computing power. A context window
				-- of 512, serves as an good starting point to estimate your computing
				-- power. Once you have a reliable estimate of your local computing power,
				-- you should adjust the context window to a larger value.
				context_window = 2048,
				provider_options = {
					openai_fim_compatible = {
						api_key = function()
							return "LM_STUDIO_API_KEY"
						end,
						name = "lm_studio",
						end_point = "http://127.0.0.1:1234/v1/completions",
						model = "qwen2.5-coder-1.5b-instruct",
						optional = {
							max_tokens = 50,
						},
						stream = true,
						template = {
							-- prompt = function(context_before_cursor, context_after_cursor) end,
							-- suffix = function(context_before_cursor, context_after_cursor) end,

							prompt = function(pref, suff)
								local prompt_message = ""
								local cache_result = vectorcode_cacher.query_from_cache(0)
								for _, file in ipairs(cache_result) do
									prompt_message = prompt_message
										.. "<|file_sep|>"
										.. file.path
										.. "\n"
										.. file.document
								end
								return prompt_message
									.. "<|fim_prefix|>"
									.. pref
									.. "<|fim_suffix|>"
									.. suff
									.. "<|fim_middle|>"
							end,
							suffix = false,
						},
					},
				},
				virtualtext = {
					auto_trigger_ft = { "*" },
					keymap = {
						-- accept whole completion
						accept = "<a-l>",
						-- accept one line
						-- accept_line = "<c-a>",
						-- accept n lines (prompts for number)
						-- e.g. "A-z 2 CR" will accept 2 lines
						-- accept_n_lines = "<A-z>",
						-- Cycle to prev completion item, or manually invoke completion
						prev = "<C-k>",
						-- Cycle to next completion item, or manually invoke completion
						next = "<C-j>",
						dismiss = "<a-h>",
					},
				},
			})
		end,
	},
	{
		"olimorris/codecompanion.nvim",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				-- Change the default chat adapter
				chat = {
					adapter = "lm_studio",
				},
			},
			display = {
				action_palette = {
					width = 60,
					height = 10,
					prompt = "Prompt ", -- Prompt used for interactive LLM calls
					provider = "telescope", -- default|telescope|mini_pick
					opts = {
						show_default_actions = true, -- Show the default actions in the action palette?
						show_default_prompt_library = true, -- Show the default prompt library in the action palette?
					},
				},
				chat = {

					window = {
						layout = "float",
						height = 0.65,
						width = 0.75,
					},
				},
			},
			adapters = {
				lm_studio = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "http://127.0.0.1:1234",
						},
						schema = {
							model = {
								default = "qwen2.5.1-coder-14b-instruct",
								chat_url = "/v1/chat/completions",
							},
						},
					})
				end,
			},
		},

		keys = {
			{ "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "[C]odecompanion [A]ctions" },
			{ "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "[C]odecompanionChat [T]oggle" },
			{ "<leader>cA", "<cmd>CodeCompanionChat Add<cr>", desc = "[C]odecompanionChat [A]dd" },
		},
	},
}
