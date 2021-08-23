local cachepath = vim.fn.stdpath "cache"
local opt       = vim.opt
local g         = vim.g

-- require for completion plugin
opt.completeopt = { "menuone", "noselect" }

opt.undofile    = true
opt.undodir     = cachepath .. 'undo/'

opt.backup      = false
opt.writebackup = false

opt.hidden      = true
opt.ignorecase  = true
opt.smartcase   = true
opt.splitbelow  = true
opt.splitright  = true
opt.cursorline  = true
opt.mouse       = "a"
opt.signcolumn  = "yes"
opt.clipboard   = "unnamedplus"
opt.cmdheight   = 1
opt.scrolloff   = 8
opt.sidescrolloff = 9
opt.termguicolors = true

opt.shortmess:append "sI"
opt.fillchars = { eob = " " }

opt.number          = true
opt.numberwidth     = 4
opt.relativenumber  = false

opt.shiftwidth      = 4
opt.tabstop         = 4
opt.expandtab       = true
opt.smartindent     = true

-- disable builtin vim plugins
local disabled_built_ins = {
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "gzip",
   "zip",
   "zipPlugin",
   "tar",
   "tarPlugin",
   "getscript",
   "getscriptPlugin",
   "vimball",
   "vimballPlugin",
   "2html_plugin",
   "logipat",
   "rrhelper",
   "spellfile_plugin",
   "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end