return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = {
					"",
					"",
					"",
					"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
					"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
					"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
					"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
					"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
					"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
					"",
					"",
				},
				center = {
					{
						icon = "  ",
						icon_hl = "Title",
						desc = "Find File           ",
						desc_hl = "String",
						key = "f",
						key_hl = "Number",
						action = "Telescope find_files",
					},
					{
						icon = "  ",
						icon_hl = "Title",
						desc = "Recent Files        ",
						desc_hl = "String",
						key = "r",
						key_hl = "Number",
						action = "Telescope oldfiles",
					},
					{
						icon = "  ",
						icon_hl = "Title",
						desc = "Find Word           ",
						desc_hl = "String",
						key = "g",
						key_hl = "Number",
						action = "Telescope live_grep",
					},
					{
						icon = "  ",
						icon_hl = "Title",
						desc = "File Explorer       ",
						desc_hl = "String",
						key = "e",
						key_hl = "Number",
						action = "Neotree toggle",
					},
					{
						icon = "  ",
						icon_hl = "Title",
						desc = "Configuration       ",
						desc_hl = "String",
						key = "c",
						key_hl = "Number",
						action = "cd ~/.dotfiles/.config/nvim | Telescope find_files",
					},
					{
						icon = "  ",
						icon_hl = "Title",
						desc = "Quit                ",
						desc_hl = "String",
						key = "q",
						key_hl = "Number",
						action = "qa",
					},
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					local version = vim.version()
					local nvim_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch

					-- Get language versions
					local function get_version(cmd)
						local handle = io.popen(cmd .. " 2>&1")
						if handle then
							local result = handle:read("*a")
							handle:close()
							return result:match("^%s*(.-)%s*$") -- trim whitespace
						end
						return nil
					end

					local function pad_right(str, width)
						return str .. string.rep(" ", width - #str)
					end

					-- Collect language versions
					local langs = {
						{ name = "Neovim", version = nvim_version },
						{ name = "Node", version = get_version("node --version") },
						{ name = "TypeScript", version = get_version("tsc --version"):match("Version%s+(.+)") },
						{ name = "Python", version = get_version("python3 --version"):match("Python%s+(.+)") },
						{
							name = "Swift",
							version = get_version("swift --version | head -n 1"):match("version%s+(.+)%s+%("),
						},
						{
							name = "C++",
							version = get_version("clang++ --version | head -n 1"):match("version%s+(.+)%s+%("),
						},
						{ name = "PHP", version = get_version("php --version | head -n 1"):match("PHP%s+(.+)%s+%(") },
						{ name = "Go", version = get_version("go version"):match("go version go(.+)%s+") },
						{ name = "Rust", version = get_version("rustc --version"):match("rustc%s+(.+)%s+%(") },
						{ name = "Ruby", version = get_version("ruby --version"):match("ruby%s+(.+)%s+%(") },
					}

					-- Filter out unavailable languages
					local available = {}
					for _, lang in ipairs(langs) do
						if lang.version then
							table.insert(available, lang)
						end
					end

					-- Build table
					local footer_lines = {
						"",
						"⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						"",
						"┌─────────────────────────────────────────────────┐",
						"│              Environment Details                │",
						"├─────────────────────────────────────────────────┤",
					}

					-- Add languages in single column for simplicity
					for _, lang in ipairs(available) do
						local lang_line = "│  "
							.. pad_right(lang.name .. ":", 15)
							.. pad_right(lang.version, 31)
							.. " │"
						table.insert(footer_lines, lang_line)
					end

					table.insert(
						footer_lines,
						"└─────────────────────────────────────────────────┘"
					)
					table.insert(footer_lines, "")
					table.insert(footer_lines, "  " .. os.date("%A, %B %d, %Y"))

					return footer_lines
				end,
			},
		})
	end,
}
