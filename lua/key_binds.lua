local set = vim.keymap.set;

-- Disable arrow keys #
set('n', '<Up>', '<Nop<')
set('n', '<Down>', '<Nop<')
set('n', '<Left>', '<Nop<')
set('n', '<Right>', '<Nop<')

set('v', '<Up>', '<Nop<')
set('v', '<Down>', '<Nop<')
set('v', '<Left>', '<Nop<')
set('v', '<Right>', '<Nop<')

set('o', '<Up>', '<Nop<')
set('o', '<Down>', '<Nop<')
set('o', '<Left>', '<Nop<')
set('o', '<Right>', '<Nop<')


-- Telescope #
local builtin = require('telescope.builtin')
set('n', '<leader>ff', builtin.find_files, {})
set('n', '<leader>fg', builtin.live_grep, {})

-- Move text up/down #
set('v', 'J', ':m ">+1<CR>gv=gv')
set('v', 'K', ':m "<-2<CR>gv=gv')

-- Keep cursor in the middle #
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')

-- copy to system clipboard #
set('n', 'y', '"+y')
set('v', 'y', '"+y')

-- paste from system clipboard #
set('n', 'p', '"+p')
set('v', 'p', '"+p')

-- cut to system clipboard #
set('n', 'c', '"+c')
set('v', 'c', '"+c')

-- delete into the void #
set('n', 'd', '"_d')
set('v', 'd', '"_d')

-- Dont press Q #
set('n', 'Q', '')

-- replace all words under cursor #
set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

--open nvim tree #
local api = require 'nvim-tree.api'
set('n', '<leader>E', api.tree.open, {})

-- toggle nvim-tree #
set('n', '<leader>n', api.tree.toggle, {})

-- comment out lines #
set('v', '<leader>#', [[:s/^/]])

-- code actions #
set('n', '<leader>a', vim.lsp.buf.code_action, {})

-- Trouble #
set('n', '<leader>tt', function()
  -- Document diagnostics (current buffer)
  require('trouble').toggle({ mode = 'diagnostics', focus = true, filter = { buf = 0 } })
end, { desc = 'Trouble: Document diagnostics' })

-- Terminal #
set('n', '<leader>T', [[:terminal<CR>i]])

-- Debugging #
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func)
      vim.keymap.set("n", keys, func, { buffer = event.buf })
    end
    map("<leader>rn", vim.lsp.buf.rename)
  end
})

local dap = require('dap')
set('n', '<leader>db', dap.toggle_breakpoint, {})
set('n', '<leader>dc', dap.continue, {})
set('n', '<leader>dn', dap.step_over, {})
set('n', '<leader>di', dap.step_into, {})
set('n', '<leader>do', dap.step_out, {})
