return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
			"wojciech-kulik/xcodebuild.nvim", -- For Swift/iOS debugging
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Setup DAP UI
			dapui.setup()

			-- Setup virtual text
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				virt_text_pos = "eol",
			})

			-- Auto open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- DAP signs
			vim.fn.sign_define("DapBreakpoint", {
				text = "",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = "",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "",
				texthl = "DapBreakpointRejected",
				linehl = "",
				numhl = "",
			})

			-- Swift/iOS debugging setup
			local xcodebuild = require("xcodebuild.integrations.dap")
			local codelldbPath = os.getenv("HOME") .. "/tools/codelldb-aarch64-darwin/extension/adapter/codelldb"

			-- Check if codelldb exists
			if vim.fn.filereadable(codelldbPath) == 1 then
				xcodebuild.setup(codelldbPath)
			else
				vim.notify(
					"codelldb not found at "
						.. codelldbPath
						.. "\nDownload from: https://github.com/vadimcn/codelldb/releases",
					vim.log.levels.WARN
				)
			end

			-- General keymaps
			local opts = { noremap = true, silent = true }

			vim.keymap.set(
				"n",
				"<leader>db",
				dap.toggle_breakpoint,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Toggle breakpoint",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dB",
				function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Set conditional breakpoint",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dc",
				dap.continue,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Continue",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dC",
				dap.run_to_cursor,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Run to cursor",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>di",
				dap.step_into,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Step into",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>do",
				dap.step_over,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Step over",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dO",
				dap.step_out,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Step out",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dq",
				dap.terminate,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Terminate",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dr",
				dap.restart,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Restart",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>du",
				dapui.toggle,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Toggle UI",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Hover",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dp",
				function()
					require("dap.ui.widgets").preview()
				end,
				vim.tbl_extend("force", opts, {
					desc = "DAP: Preview",
				})
			)

			-- Swift/iOS specific keymaps (integrated with xcodebuild.nvim)
			vim.keymap.set(
				"n",
				"<leader>dd",
				xcodebuild.build_and_debug,
				vim.tbl_extend("force", opts, {
					desc = "Xcode: Build & debug",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dR",
				xcodebuild.debug_without_build,
				vim.tbl_extend("force", opts, {
					desc = "Xcode: Debug without building",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dt",
				xcodebuild.debug_tests,
				vim.tbl_extend("force", opts, {
					desc = "Xcode: Debug tests",
				})
			)

			vim.keymap.set(
				"n",
				"<leader>dT",
				xcodebuild.debug_class_tests,
				vim.tbl_extend("force", opts, {
					desc = "Xcode: Debug class tests",
				})
			)
		end,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = {
			"mfussenegger/nvim-dap",
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			},
		},
		config = function()
			require("dap-vscode-js").setup({
				node_path = "node",
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
				adapters = {
					"pwa-node",
					"pwa-chrome",
					"pwa-msedge",
					"node-terminal",
					"pwa-extensionHost",
				},
			})

			local dap = require("dap")

			-- TypeScript/JavaScript configurations
			for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						protocol = "inspector",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest Tests",
						runtimeExecutable = "node",
						runtimeArgs = {
							"./node_modules/jest/bin/jest.js",
							"--runInBand",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch Chrome",
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
					},
				}
			end
		end,
	},
}
