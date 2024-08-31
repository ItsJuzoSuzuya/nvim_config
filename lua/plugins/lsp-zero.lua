return { {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    {
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
      opts = {
        ensure_installed = {
          "cmake",
          "clang",
          "clangd",
          "rustup",
          "rust-analyzer",
          "pyright",
          "texlab",
          "lua-language-server",
          "pylsp",
          "codelldb",
        }
      },
    },
    {
      "williamboman/mason-lspconfig.nvim",
    },
    {

      "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require('cmp')
        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<Tab>'] = cmp.mapping.select_next_item(),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = 'nvim_lua' },
          }),
        })
      end,
    },
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    { "lukas-reineke/lsp-format.nvim", config = true },
  },
  config = function()
    local lsp = require("lsp-zero")
    lsp.preset("recommended")
    lsp.on_attach(function(client, bufnr)
      require("lsp-format").on_attach(client, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end)
    lsp.setup_servers({
      'pyright',
      'rust_analyzer',
      'lua_ls',
      'clangd',
      'texlab',
      'pylsp'
    })
    lsp.setup()
    vim.diagnostic.config { virtual_text = true }
  end
} }
