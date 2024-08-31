local opt = vim.opt

opt.mouse = ""

opt.runtimepath:append(os.getenv("HOME") .. "/.vim/parsers")

opt.nu             = true
opt.relativenumber = true

opt.tabstop        = 2
opt.softtabstop    = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.smartindent    = false

opt.wrap           = false
opt.swapfile       = false
opt.backup         = false
opt.undodir        = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile       = true

opt.hlsearch       = false
opt.incsearch      = true
opt.termguicolors  = true

opt.scrolloff      = 8
opt.signcolumn     = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50
opt.completeopt = "noselect,noinsert"

opt.showmode = false

opt.cmdheight = 0

opt.spelllang = "en_us"
