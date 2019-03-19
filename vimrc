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

Plug 'Yggdroot/indentLine'

Plug 'mileszs/ack.vim'

Plug 'junegunn/goyo.vim'

Plug 'fisadev/vim-isort'

Plug 'KabbAmine/zeavim.vim'

Plug 'myusuf3/numbers.vim'

Plug 'ambv/black'

Plug 'jiangmiao/auto-pairs'

Plug 'w0rp/ale'

" Initialize plugin system
call plug#end()


let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let mapleader = ","

nmap <F8> :TagbarToggle<CR>
nmap <F3> :cprevious<CR>
nmap <F4> :cnext<CR>

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

nmap <space>1 :only<CR>
nmap <space>2 :split<CR>
nmap <space>3 :vsplit<CR>
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
" 使import from import 能正常工作
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

autocmd FileType  python autocmd BufWritePre <buffer> %s/\s\+$//e
autocmd BufWritePre *.py 0,$!yapf

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

function GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

map <leader>z :Goyo<cr>
let g:ctrlp_map = '<c-f>'
