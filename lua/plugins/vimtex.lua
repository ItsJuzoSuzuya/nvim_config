return { {
  'lervag/vimtex',
  ft = { 'tex' },
  config = function()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_quickfix_enabled = 0
  end
} }
