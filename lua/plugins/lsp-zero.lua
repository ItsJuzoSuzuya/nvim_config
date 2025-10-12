return { {
  'VonHeikemen/lsp-zero.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    {
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup()
      end,
      opts = {
        ensure_installed = {
          'cmake',
          'clangd',
          'rustup',
          'rust-analyzer',
          'pyright',
          'texlab',
          'lua-language-server',
          'codelldb',
          'docker_compose_language_service',
          'dockerls',
          'intelephense',
          'zls',
        }
      },
    },
    {
      'williamboman/mason-lspconfig.nvim',
    },
    {
      'hrsh7th/nvim-cmp',
      config = function()
        local cmp = require('cmp')
        cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
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
    'L3MON4D3/LuaSnip',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    { 'lukas-reineke/lsp-format.nvim', config = true },
  },
  config = function()
    local lsp = require('lsp-zero')
    lsp.on_attach(function(client, bufnr)
      require('lsp-format').on_attach(client, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end)
    require('lspconfig').pyright.setup({
      settings = {
        python = {
          pythonPath = '/home/nick/.local/share/pipx/venvs/pip/bin/python'
        }
      }
    })
    require('lspconfig').intelephense.setup({
      root_dir = function(fname)
        return require('lspconfig').util.root_pattern('composer.json', '.git')(fname) or
            require('lspconfig').util.path.dirname(fname)
      end,

    })
    lsp.setup_servers({
      'cmake',
      'pyright',
      'rust_analyzer',
      'lua_ls',
      'clangd',
      'texlab',
      'ts_ls',
      'docker_compose_language_service',
      'dockerls',
      'glsl_analyzer',
      'intelephense',
      'zls',
    })

    lsp.configure('intelephense', {
      settings = {
        intelephense = {
          files = {
            maxSize = 5000000
          }
        }
      }
    })

    lsp.setup()
    lsp.configure('clangd', {
      cmd = {
        'clangd',
        '--compile-commands-dir=build',
        '--header-insertion=never',
        '--all-scopes-completion',
      },
      root_dir = require('lspconfig').util.root_pattern('compile_commands.json', '.git'),
    })
    vim.diagnostic.config { virtual_text = true }
  end
} }
