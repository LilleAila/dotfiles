local o = vim.opt
local g = vim.g

-- 2-space indents
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.autoindent = true
o.smartindent = true
o.breakindent = true

-- Searching
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

-- Splitting
o.splitbelow = true
o.splitright = true

-- Undo
o.undofile = true
o.undolevels = 10000
o.swapfile = false
o.backup = false

-- Disable folding
o.foldlevel = 99
o.foldlevelstart = 99

-- Misc
o.termguicolors = true
o.timeoutlen = 1000
o.scrolloff = 4
o.sidescrolloff = 4
o.cursorline = true
o.encoding = "utf-8"
o.fileencoding = "utf-8"
o.fillchars = "eob: " -- Disable the "~" chars at end of buffer
o.number = true
o.relativenumber = true

g.mapleader = " "
o.clipboard = "unnamedplus"

vim.cmd.colorscheme("nix")
