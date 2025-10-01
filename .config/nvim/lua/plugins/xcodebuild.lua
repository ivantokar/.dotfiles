return {
	"wojciech-kulik/xcodebuild.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-neo-tree/neo-tree.nvim", -- optional, for integration
	},
	config = function()
		require("xcodebuild").setup({
			-- Automatically save files before building
			restore_on_start = true,
			-- Show build progress
			show_build_progress_bar = true,
			-- Logs settings
			logs = {
				auto_open_on_success_tests = false,
				auto_open_on_failed_tests = true,
				auto_open_on_success_build = false,
				auto_open_on_failed_build = true,
				auto_close_on_success = false,
				auto_focus = true,
				only_summary = false,
				show_warnings = true,
				notify = function(message, severity)
					vim.notify(message, severity)
				end,
			},
			-- Console settings
			console_logs = {
				enabled = true,
				format_line = function(line)
					return line
				end,
				filter_line = function(line)
					return true
				end,
			},
			-- Code coverage
			code_coverage = {
				enabled = false,
			},
		})

		-- Keymaps
		local opts = { noremap = true, silent = true }

		vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Build project",
		}))

		vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Build & run project",
		}))

		vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Run tests",
		}))

		vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Run test class",
		}))

		vim.keymap.set("n", "<leader>x.", "<cmd>XcodebuildTestRepeat<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Repeat last test",
		}))

		vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Toggle logs",
		}))

		vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Toggle code coverage",
		}))

		vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Show coverage report",
		}))

		vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Select device",
		}))

		vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Select test plan",
		}))

		vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildSelectScheme<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Select scheme",
		}))

		vim.keymap.set("n", "<leader>xq", "<cmd>XcodebuildQuickfixLine<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Quickfix line",
		}))

		vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Code actions",
		}))

		vim.keymap.set("n", "<leader>xX", "<cmd>XcodebuildCleanProject<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Clean project",
		}))

		vim.keymap.set("n", "<leader>xx", "<cmd>XcodebuildPicker<cr>", vim.tbl_extend("force", opts, {
			desc = "Xcode: Show all commands",
		}))
	end,
}
