syntax on 
set ttyfast
set number
set nowrap
set showmatch
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set shiftwidth=4
set smarttab
set ruler
set noswapfile
set laststatus=2
set cmdheight=1
set showtabline=2
set clipboard=unnamedplus
set termguicolors
set colorcolumn=79
set cursorline
set wildoptions-=pum
set completeopt=menuone,noinsert,noselect
set completeopt+=menuone
set wildmode=longest:full,full

function! GetMode()
  let l:mode = mode()
  return l:mode ==# 'n'  ? '-- NORMAL --' :
        \ l:mode ==# 'i'  ? '-- INSERT --' :
        \ l:mode ==# 'R'  ? '-- REPLACE --' :
        \ l:mode ==# 'v'  ? '-- VISUAL --' :
        \ l:mode ==# 'V'  ? '-- V-LINE --' :
        \ l:mode ==# "\<C-v>" ? '-- V-BLOCK --' :
        \ l:mode ==# 'c'  ? '-- COMMAND --' :
        \ l:mode ==# 's'  ? '-- SELECT --' :
        \ l:mode ==# 'S'  ? '-- S-LINE --' :
        \ l:mode ==# "\<C-s>" ? '-- S-BLOCK --' :
        \ l:mode ==# 't'  ? '-- TERMINAL --' :
        \ '-- UNKNOWN --'
endfunction

inoremap <C-Space> <C-n>
set laststatus=2
set statusline=%{GetMode()}%=%{&filetype}\ \|\ %{&fileformat}\ \|\ row\ %l,\ col\ %c\ \|\ %p%%\ 
set noshowmode
set fillchars=eob:+
colorscheme monokai 

let g:python_highlight_all = 1
let g:python_highlight_indent_errors = 0
let g:python_highlight_space_errors = 0
let c_hi_identifiers = 'all'
let c_hi_libs = ['*']
