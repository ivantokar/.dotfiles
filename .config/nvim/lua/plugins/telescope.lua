return {
	{
		"nvim-telescope/telescope.nvim",

		tag = "0.1.8",
		lazy = false, -- Load at startup to avoid delay on first use
		priority = 100, -- Load early

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},

		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			local lga_actions = require("telescope-live-grep-args.actions")

			telescope.setup({
				defaults = {
					-- Prompt and results icons
					prompt_prefix = "  ",
					selection_caret = " ",
					entry_prefix = "  ",
					multi_icon = " ",

					-- Performance improvements
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--max-filesize=1M", -- Skip files larger than 1MB
						-- Exclude large directories for faster search
						"--glob=!.git/",
						"--glob=!node_modules/",
						"--glob=!dist/",
						"--glob=!build/",
						"--glob=!target/",
						"--glob=!vendor/",
						"--glob=!.next/",
						"--glob=!.nuxt/",
						"--glob=!.cache/",
						"--glob=!*.min.js",
						"--glob=!*.min.css",
						"--glob=!package-lock.json",
						"--glob=!yarn.lock",
						"--glob=!pnpm-lock.yaml",
						-- Swift/iOS/Xcode exclusions
						"--glob=!*.xcodeproj/",
						"--glob=!*.xcworkspace/",
						"--glob=!DerivedData/",
						"--glob=!.build/",
						"--glob=!.swiftpm/",
						"--glob=!Pods/",
						"--glob=!Carthage/",
						"--glob=!*.framework/",
						"--glob=!*.dSYM/",
						-- Removed --hidden for better performance (use <C-g> in live_grep to add it)
					},

					-- Better file ignoring
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"dist/",
						"build/",
						"target/",
						"vendor/",
						"%.lock",
						"%.min.js",
						"%.min.css",
						"package%-lock.json",
						"yarn.lock",
						"%.jpg",
						"%.jpeg",
						"%.png",
						"%.svg",
						"%.otf",
						"%.ttf",
					},

					-- Layout improvements
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},

					-- Better sorting
					sorting_strategy = "ascending",
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

					-- Path display
					path_display = { "truncate" },

					-- Better preview
					winblend = 0,
					border = {},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					set_env = { ["COLORTERM"] = "truecolor" },

					-- Mappings
					mappings = {
						i = {
							["<C-h>"] = "which_key",
							["<C-d>"] = actions.delete_buffer,
							["<C-u>"] = false, -- Clear prompt
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						},
						n = {
							["<C-d>"] = actions.delete_buffer,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						},
					},
				},

				pickers = {
					find_files = {
						hidden = true,
						find_command = { "rg", "--files", "--hidden", "--glob", "!.git/" },
					},
					buffers = {
						sort_lastused = true,
						sort_mru = true,
						mappings = {
							i = {
								["<C-d>"] = actions.delete_buffer,
							},
							n = {
								["<C-d>"] = actions.delete_buffer,
							},
						},
					},
					git_files = {
						show_untracked = true,
					},
					oldfiles = {
						cwd_only = true,
					},
				},

				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					live_grep_args = {
						auto_quoting = true,
						-- Ensure it uses the same vimgrep_arguments
						vimgrep_arguments = {
							"rg",
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
							"--max-filesize=1M",
							"--glob=!.git/",
							"--glob=!node_modules/",
							"--glob=!dist/",
							"--glob=!build/",
							"--glob=!target/",
							"--glob=!vendor/",
							"--glob=!.next/",
							"--glob=!.nuxt/",
							"--glob=!.cache/",
							"--glob=!*.min.js",
							"--glob=!*.min.css",
							"--glob=!package-lock.json",
							"--glob=!yarn.lock",
							"--glob=!pnpm-lock.yaml",
							"--glob=!*.xcodeproj/",
							"--glob=!*.xcworkspace/",
							"--glob=!DerivedData/",
							"--glob=!.build/",
							"--glob=!.swiftpm/",
							"--glob=!Pods/",
							"--glob=!Carthage/",
							"--glob=!*.framework/",
							"--glob=!*.dSYM/",
						},
						mappings = {
							i = {
								["<C-k>"] = lga_actions.quote_prompt(),
								["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
								-- Add hidden files flag
								["<C-g>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
							},
						},
					},
				},
			})

			-- Load extensions
			telescope.load_extension("fzf")
			telescope.load_extension("live_grep_args")
			telescope.load_extension("notify")

			-- Keymaps
			local opts = { silent = true }
			local lga_shortcuts = require("telescope-live-grep-args.shortcuts")

			-- File pickers
			vim.keymap.set("n", "<leader>ff", builtin.find_files, vim.tbl_extend("force", opts, {
				desc = "Telescope: Find files",
			}))

			vim.keymap.set("n", "<leader>fa", function()
				builtin.find_files({ no_ignore = true, hidden = true })
			end, vim.tbl_extend("force", opts, {
				desc = "Telescope: Find all files (no ignore)",
			}))

			vim.keymap.set("n", "<leader>fg", telescope.extensions.live_grep_args.live_grep_args, vim.tbl_extend("force", opts, {
				desc = "Telescope: Live grep with args",
			}))

			vim.keymap.set("n", "<leader>fw", builtin.grep_string, vim.tbl_extend("force", opts, {
				desc = "Telescope: Grep current word",
			}))

			vim.keymap.set("n", "<leader>fb", builtin.buffers, vim.tbl_extend("force", opts, {
				desc = "Telescope: Find buffers",
			}))

			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, vim.tbl_extend("force", opts, {
				desc = "Telescope: Recent files",
			}))

			vim.keymap.set("n", "<leader>fo", builtin.resume, vim.tbl_extend("force", opts, {
				desc = "Telescope: Resume last picker",
			}))

			-- Vim pickers
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, vim.tbl_extend("force", opts, {
				desc = "Telescope: Help tags",
			}))

			vim.keymap.set("n", "<leader>fk", builtin.keymaps, vim.tbl_extend("force", opts, {
				desc = "Telescope: Keymaps",
			}))

			vim.keymap.set("n", "<leader>fc", builtin.commands, vim.tbl_extend("force", opts, {
				desc = "Telescope: Commands",
			}))

			vim.keymap.set("n", "<leader>fm", builtin.marks, vim.tbl_extend("force", opts, {
				desc = "Telescope: Marks",
			}))

			vim.keymap.set("n", "<leader>fR", builtin.registers, vim.tbl_extend("force", opts, {
				desc = "Telescope: Registers",
			}))

			vim.keymap.set("n", "<leader>fj", builtin.jumplist, vim.tbl_extend("force", opts, {
				desc = "Telescope: Jump list",
			}))

			-- Git pickers
			vim.keymap.set("n", "<leader>fgf", builtin.git_files, vim.tbl_extend("force", opts, {
				desc = "Telescope: Git files",
			}))

			vim.keymap.set("n", "<leader>fgs", builtin.git_status, vim.tbl_extend("force", opts, {
				desc = "Telescope: Git status",
			}))

			vim.keymap.set("n", "<leader>fgc", builtin.git_commits, vim.tbl_extend("force", opts, {
				desc = "Telescope: Git commits",
			}))

			vim.keymap.set("n", "<leader>fgb", builtin.git_branches, vim.tbl_extend("force", opts, {
				desc = "Telescope: Git branches",
			}))

			-- LSP pickers (already have in lsp.lua, but adding consistency)
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, vim.tbl_extend("force", opts, {
				desc = "Telescope: Diagnostics",
			}))
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",

		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})

			require("telescope").load_extension("ui-select")
		end,
	},
}
