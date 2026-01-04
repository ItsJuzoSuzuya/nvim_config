return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    build = ":TSUpdate",
    -- load at startup and prefer it earlier in runtimepath
    lazy = false,
    priority = 1000,
    dependencies = {
      -- disabled/lazy so they don't get sourced before treesitter
      -- remove the following entries if you don't want them at all
      { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
      { "nvim-treesitter/nvim-treesitter-context", lazy = true },
    },
    config = function()
      -- make sure the plugin runtime is added so require() can find lua modules
      pcall(vim.cmd, "packadd nvim-treesitter")

      local ok, configs_or_err = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter not available; skipping setup: " .. tostring(configs_or_err), vim.log.levels.WARN)
        return
      end

      configs_or_err.setup({
        ensure_installed = { "lua", "c", "rust", "markdown", "java" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = false },
      })
    end,
  },
}
