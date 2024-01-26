return {
    {
        "nvim-treesitter/nvim-treesitter",
        enable = true,
        build = function()
            require("nvim-treesitter.insatll").update({ with_sync = true })()
        end,
        init = function(plugin)
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "lua", "c", "rust", "markdown", "java" },

                auto_install = true,
                indent = { enable = true },
                incremental_selection = { enable = false },
            }
        end,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects", {} },
            {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    mode = "cursor", max_lines = 3
                },
            },
        }
    }
}
