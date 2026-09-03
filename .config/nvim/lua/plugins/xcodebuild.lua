-- Restore the Xcode build, test, simulator, and log workflow.
return {
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      restore_on_start = true,
      show_build_progress_bar = true,
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
      console_logs = {
        enabled = true,
      },
      code_coverage = {
        enabled = false,
      },
    },
    keys = {
      { "<leader>Xb", "<cmd>XcodebuildBuild<cr>", desc = "Xcode: Build project" },
      { "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Xcode: Build and run" },
      { "<leader>Xt", "<cmd>XcodebuildTest<cr>", desc = "Xcode: Run tests" },
      { "<leader>XT", "<cmd>XcodebuildTestClass<cr>", desc = "Xcode: Test class" },
      { "<leader>X.", "<cmd>XcodebuildTestRepeat<cr>", desc = "Xcode: Repeat test" },
      { "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Xcode: Toggle logs" },
      { "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Xcode: Toggle coverage" },
      { "<leader>XC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", desc = "Xcode: Coverage report" },
      { "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Xcode: Select device" },
      { "<leader>Xp", "<cmd>XcodebuildSelectTestPlan<cr>", desc = "Xcode: Select test plan" },
      { "<leader>Xs", "<cmd>XcodebuildSelectScheme<cr>", desc = "Xcode: Select scheme" },
      { "<leader>Xq", "<cmd>XcodebuildQuickfixLine<cr>", desc = "Xcode: Quickfix line" },
      { "<leader>Xa", "<cmd>XcodebuildCodeActions<cr>", desc = "Xcode: Code actions" },
      { "<leader>XX", "<cmd>XcodebuildCleanProject<cr>", desc = "Xcode: Clean project" },
      { "<leader>Xx", "<cmd>XcodebuildPicker<cr>", desc = "Xcode: Show commands" },
    },
  },
}
