local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

local ft_lsp_group = vim.api.nvim_create_augroup("ft_lsp_group",{clear=true})
vim.api.nvim_create_autocmd({"BufReadPost","BufNewFile"},{
    pattern={"docker-compose.yaml","compose.yaml"},
    group = ft_lsp_group,
    desc = "Fix the issue where the LSP does not start with docker-compose.",
    callback = function ()
        vim.opt.filetype = "yaml.docker-compose"
    end
})

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.python3_host_prog = '/home/nick/.local/share/pipx/venvs/pip/bin/python'

require "settings"
require("lazy").setup("plugins")
require "key_binds"
