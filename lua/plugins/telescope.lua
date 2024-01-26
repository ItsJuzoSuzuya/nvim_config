return{
	{"nvim-telescope/telescope.nvim", 
		config = function()
			require("telescope").setup {
				defaults = {},
				extentions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown {}
				}
			}
		end,

		dependencies = { 
			'nvim-lua/plenary.nvim',  
			{"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
			{"nvim-telescope/telescope-ui-select.nvim",
				config = function()
					require("telescope").load_extension("ui-select")
				end,
			},
		},	
	}
}
