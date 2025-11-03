return {
	-- Lualine

	"nvim-lualine/lualine.nvim",

	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local function xcodebuild_device()
			if vim.g.xcodebuild_platform == "macOS" then
				return " macOS"
			end

			local deviceIcon = ""
			if vim.g.xcodebuild_platform:match("watch") then
				deviceIcon = "􀟤"
			elseif vim.g.xcodebuild_platform:match("tv") then
				deviceIcon = "􀡴 "
			elseif vim.g.xcodebuild_platform:match("vision") then
				deviceIcon = "􁎖 "
			end

			if vim.g.xcodebuild_os then
				return deviceIcon .. " " .. vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")"
			end

			return deviceIcon .. " " .. vim.g.xcodebuild_device_name
		end

		-- LSP server names
		local function lsp_servers()
			local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
			if #buf_clients == 0 then
				return ""
			end

			local buf_client_names = {}
			for _, client in pairs(buf_clients) do
				if client.name ~= "null-ls" and client.name ~= "copilot" then
					table.insert(buf_client_names, client.name)
				end
			end

			if #buf_client_names > 0 then
				return "LSP:" .. table.concat(buf_client_names, ", ")
			end
			return ""
		end

		-- Word count for markdown/text files
		local function word_count()
			local ft = vim.bo.filetype
			if ft == "markdown" or ft == "text" or ft == "tex" then
				local words = vim.fn.wordcount().words
				return words .. " words"
			end
			return ""
		end

		-- Search count
		local function search_count()
			if vim.v.hlsearch == 0 then
				return ""
			end

			local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
			if not ok or result.total == 0 then
				return ""
			end

			if result.incomplete == 1 then
				return "?/?"
			end

			return string.format("%d/%d", result.current, result.total)
		end

		-- Macro recording indicator
		local function macro_recording()
			local recording_register = vim.fn.reg_recording()
			if recording_register == "" then
				return ""
			else
				return "Recording @" .. recording_register
			end
		end

		-- Lazy.nvim updates indicator
		local function lazy_updates()
			local ok, lazy_status = pcall(require, "lazy.status")
			if ok and lazy_status.has_updates() then
				return lazy_status.updates()
			end
			return ""
		end

		-- Indent size
		local function indent_size()
			if vim.bo.expandtab then
				return "S:" .. vim.bo.shiftwidth
			else
				return "T:" .. vim.bo.tabstop
			end
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				section_separators = { left = "", right = "" },
				component_separators = { left = "│", right = "│" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = {
					{ "mode", icon = "" },
					{ macro_recording, color = { fg = "#f38ba8", gui = "bold" } },
				},
				lualine_b = {
					{ "branch", icon = "", color = { fg = "#a6e3a1" } },
					{
						"diff",
						symbols = { added = "+", modified = "~", removed = "-" },
						diff_color = {
							added = { fg = "#a6e3a1" },
							modified = { fg = "#f9e2af" },
							removed = { fg = "#f38ba8" },
						},
					},
					{
						"diagnostics",
						symbols = { error = " ", warn = " ", info = "ⓘ ", hint = " " },
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						symbols = {
							modified = " ●",
							readonly = " ",
							unnamed = "[No Name]",
						},
					},
					{ search_count, icon = "", color = { fg = "#89b4fa" } },
				},

				lualine_x = {
					{ lazy_updates, icon = "󰉁", color = { fg = "#f9e2af" } },
					{ "' ' .. vim.g.xcodebuild_last_status", color = { fg = "Gray" } },
					{ "'󰙨 ' .. vim.g.xcodebuild_test_plan", color = { fg = "#a6e3a1", bg = "#161622" } },
					{ xcodebuild_device, color = { fg = "#f9e2af", bg = "#161622" } },
					{ lsp_servers, icon = "", color = { fg = "#89dceb" } },
					{ word_count, icon = "󰈭", color = { fg = "#cba6f7" } },
					{ indent_size, icon = "󰞔", color = { fg = "#94e2d5" } },
					{ "encoding", icon = "󰯃" },
					{ "filetype", icon = "" },
				},
				lualine_y = { "progress" },
				lualine_z = {
					{ "location", icon = "" },
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
