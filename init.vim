set number
set mouse=a
syntax enable
set showcmd
set showmatch
set relativenumber

call plug#begin('~/.vim/plugged')

" Theme
Plug 'sainnhe/gruvbox-material'

" LSP
Plug 'neovim/nvim-lspconfig'

call plug#end()

" gruvbox config
set background=dark
let g:gruvbox_material_background='medium'
colorscheme gruvbox-material

" LSP config
lua <<EOF
require'lspconfig'.pyright.setup{}
EOF
