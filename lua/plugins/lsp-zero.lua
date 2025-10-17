return {{
  -- Vanilla LSP setup (no lsp-zero)
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Autocompletion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-buffer" },
    { "L3MON4D3/LuaSnip" },
    { "onsails/lspkind-nvim" },

    -- Formatting on save
    { "lukas-reineke/lsp-format.nvim", config = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

    -- Mason
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "cmake",
        "clangd",
        "pyright",
        "texlab",
        "docker_compose_language_service",
        "dockerls",
        "intelephense",
        "zls",
        "lua_ls",
        "ts_ls",       -- tsserver -> ts_ls
        "tailwindcss",
        "vue_ls",      -- volar -> vue_ls
        "eslint",
        "glsl_analyzer",
        "rust_analyzer",
      },
      handlers = {
        -- Default handler for all servers
        function(server)
          lspconfig[server].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = function(client, bufnr)
              require("lsp-format").on_attach(client, bufnr)
            end,
          })
        end,

        -- Per-server overrides
        pyright = function()
          lspconfig.pyright.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = function(client, bufnr)
              require("lsp-format").on_attach(client, bufnr)
            end,
            settings = {
              python = {
                pythonPath = "/home/nick/.local/share/pipx/venvs/pip/bin/python",
              },
            },
          })
        end,

        intelephense = function()
          lspconfig.intelephense.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = function(client, bufnr)
              require("lsp-format").on_attach(client, bufnr)
            end,
            root_dir = function(fname)
              return util.root_pattern("composer.json", ".git")(fname) or util.path.dirname(fname)
            end,
            settings = {
              intelephense = {
                files = { maxSize = 5000000 },
              },
            },
          })
        end,

        tailwindcss = function()
          lspconfig.tailwindcss.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = function(client, bufnr)
              require("lsp-format").on_attach(client, bufnr)
            end,
            filetypes = { "html", "vue", "typescriptreact", "javascriptreact", "css" },
          })
        end,

        clangd = function()
          lspconfig.clangd.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = function(client, bufnr)
              require("lsp-format").on_attach(client, bufnr)
            end,
            cmd = {
              "clangd",
              "--compile-commands-dir=build",
              "--header-insertion=never",
              "--all-scopes-completion",
            },
            root_dir = util.root_pattern("compile_commands.json", ".git"),
          })
        end,
      },
    })

    -- Diagnostics UI
    vim.diagnostic.config({
      virtual_text = true,
      float = { border = "rounded" },
    })

    -- nvim-cmp setup
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    lspkind.init()

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          scrollbar = true,
          side_padding = 1,
          col_offset = -3,
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
          max_width = 60,
          max_height = 20,
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        }),
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local label = vim_item.abbr
          local documentation = entry.completion_item.documentation
          local docstring = ""

          if type(documentation) == "string" then
            docstring = documentation
          elseif type(documentation) == "table" and documentation.value then
            docstring = documentation.value
          end

          local fname, params = label:match("([%w_]+)%s*%((.*)%)")
          local doc_lines = {}

          if docstring ~= "" then
            table.insert(doc_lines, docstring)
          end

          if fname and params and params ~= "" and not docstring:match("[Pp]arameters?:") then
            if docstring ~= "" and params and params ~= "" then
              table.insert(doc_lines, "\n---\n")
            end
            table.insert(doc_lines, "**Parameters:**")

            for param in params:gmatch("[^,]+") do
              param = param:gsub("`", "\\`")
              table.insert(doc_lines, "  • `" .. param .. "`")
            end
          end

          entry.completion_item.documentation = {
            kind = "markdown",
            value = table.concat(doc_lines, "\n"),
          }

          vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol_text" })
          return vim_item
        end,
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      }),
      experimental = {
        ghost_text = true,
      },
    })
  end,
}}
