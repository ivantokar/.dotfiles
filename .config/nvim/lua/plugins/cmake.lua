return {
	"Civitasv/cmake-tools.nvim",
	ft = { "c", "cpp", "cmake" },
	dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
	opts = {
		cmake_command = "cmake",
		cmake_build_directory = "build/${variant:buildType}",
		-- Keep compile_commands.json symlinked in the project root so clangd finds it
		cmake_soft_link_compile_commands = true,
		cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
		cmake_dap_configuration = {
			name = "cpp",
			type = "codelldb",
			request = "launch",
			stopOnEntry = false,
			runInTerminal = true,
			console = "integratedTerminal",
		},
		cmake_executor = { name = "quickfix" },
		cmake_runner = { name = "terminal" },
	},
	config = function(_, opts)
		require("cmake-tools").setup(opts)

		local map = function(lhs, cmd, desc)
			vim.keymap.set("n", lhs, "<cmd>" .. cmd .. "<cr>", { desc = "CMake: " .. desc, silent = true })
		end
		map("<leader>cg", "CMakeGenerate", "Generate")
		map("<leader>cb", "CMakeBuild", "Build")
		map("<leader>cr", "CMakeRun", "Run")
		map("<leader>cd", "CMakeDebug", "Debug")
		map("<leader>ct", "CMakeSelectBuildType", "Select build type")
		map("<leader>cT", "CMakeSelectBuildTarget", "Select build target")
		map("<leader>cl", "CMakeSelectLaunchTarget", "Select launch target")
		map("<leader>cc", "CMakeClean", "Clean")
		map("<leader>cq", "CMakeClose", "Close executor")
	end,
}
