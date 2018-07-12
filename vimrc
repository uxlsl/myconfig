" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go'

"" Plugin options
Plug 'nsf/gocode'

Plug 'tpope/vim-fugitive'

Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-surround'

Plug 'kien/ctrlp.vim'

Plug 'majutsushi/tagbar'

Plug 'scrooloose/nerdcommenter'

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'easymotion/vim-easymotion'

Plug 'davidhalter/jedi-vim'

Plug 'altercation/vim-colors-solarized'

Plug 'tomasiser/vim-code-dark'

Plug 'scrooloose/syntastic'

Plug 'ervandew/supertab'

Plug 'townk/vim-autoclose'

Plug 'plasticboy/vim-markdown'

Plug 'godlygeek/tabular'

" Initialize plugin system
call plug#end()


let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let mapleader = ","

nmap <F8> :TagbarToggle<CR>

let g:indentLine_color_term = 239

filetype plugin on

syntax enable

colorscheme codedark

let g:airline_theme = 'codedark'

let g:syntastic_python_checkers = ['flake8']

set colorcolumn=80

set tabstop=4 
set softtabstop=4
set shiftwidth=4
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

let g:go_highlight_types = 1

set hlsearch

:hi Search ctermfg=234 ctermbg=214 guifg=#1E1E1E guibg=#FFAF00
