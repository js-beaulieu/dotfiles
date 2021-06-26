""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""
" vim-better-whitespace (whitespace management)
autocmd BufWritePre * StripWhitespace

" lightline.vim (better status bar)
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction
let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ 'tabline': {'left': [['buffers']], 'right': [['close']]},
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'cocstatus', 'currentfunction', 'gitbranch', 'readonly', 'filename', 'modified'] ]
    \ },
    \ 'component_function': {
    \   'cocstatus': 'coc#status',
    \   'currentfunction': 'CocCurrentFunction',
    \   'gitbranch': 'fugitive#head'
    \ },
    \ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
    \ 'component_type': {'buffers': 'tabsel'},
    \ }
let g:lightline#bufferline#show_number = 2

" vim-easymotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0

" netrw
let g:netrw_liststyle = 3

" commentary.vim
autocmd FileType twig setlocal commentstring={#\ %s\ #}'

" fzf
autocmd VimEnter * if isdirectory(expand("<amatch>")) | exe 'FZF! '.expand("<amatch>") | endif

" vim-gitgutter
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" vue.js
let g:polyglot_disabled = ['coffee-script', 'vue']
let g:vue_disable_pre_processors=1
autocmd FileType vue syntax sync fromstart

" ensure vim-plug is installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" plugin list
call plug#begin('~/.local/share/nvim/plugged')
Plug 'joshdick/onedark.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'chrisbra/Colorizer'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'
Plug 'sheerun/vim-polyglot'
Plug 'posva/vim-vue'
Plug 'ntpeters/vim-better-whitespace'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-rooter'
Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'ludovicchabant/vim-gutentags'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-vetur', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
Plug 'josa42/coc-sh', {'do': 'yarn install --frozen-lockfile'}
Plug 'SkyLeach/pudb.vim'
call plug#end()


""""""""""""""""""""""""""""""""""""""""
" General settings
""""""""""""""""""""""""""""""""""""""""
" turn off vi compatibility
set nocompatible

" wildmenu
set wildmenu
set wildmode=longest:full,full

" tabs
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" indentation based on filetype
filetype plugin indent on


" mouse mode on
set mouse=a

" disable backup and swap files
set nobackup
set noswapfile

" default encoding
set enc=utf-8

" don't auto-conceal stuff
set conceallevel=0

" disable netrw history
let g:netrw_dirhistmax = 0

" show tabline
set showtabline=2
set guioptions-=e

" split right and bottom by default
set splitbelow
set splitright

" json comment syntax highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

" create dirs when saving file in non-existing path
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" timeout length
set timeoutlen=1000
set ttimeoutlen=0


""""""""""""""""""""""""""""""""""""""""
" visual
""""""""""""""""""""""""""""""""""""""""
" theme
if (has("termguicolors"))
  set termguicolors
endif

set background=dark
let g:onedark_terminal_italics=1
syntax on
colorscheme onedark

" editor
set cursorline
set noshowmode
set number
set relativenumber
set showcmd
set showmatch
set fillchars=vert:\|
set signcolumn=yes
set laststatus=2
set showtabline=2
set cc=80,120


""""""""""""""""""""""""""""""""""""""""
" Key bindings
""""""""""""""""""""""""""""""""""""""""
" leader
let mapleader=","

" fzf
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>
augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
nnoremap <C-S-F> :Find<CR>

" deoplete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" lightline
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" vim-easymotion
map <leader> <Plug>(easymotion-prefix)
map / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)
map <leader>l <Plug>(easymotion-lineforward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>h <Plug>(easymotion-linebackward)

" clear search
nnoremap <leader><space> :noh<Enter>

" buffers
nnoremap <leader>q :Buffers<cr>
nmap <Leader>p :bp<cr>
nmap <Leader>n :bn<cr>

" netrw
nnoremap <leader>% :Vex!<cr>
nnoremap <leader>" :Sex<cr>

" copy to clipboard
noremap y "+y

" coc.nvim
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
noremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

command! -nargs=0 Format :call CocAction('format')
nnoremap <leader><leader>f :Format<cr>

command! -nargs=0 Prettier :CocCommand prettier.formatFile
nnoremap <leader><leader>p :Prettier<cr>

" pdb debugging
nnoremap <leader>v oimport pdb; pdb.set_trace()<Esc>

