set background=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "github_dark_classic"

hi Normal guibg=#000000 guifg=#d1d5da cterm=reverse
hi Identifier guifg=#cea5fb cterm=reverse
hi NonText guifg=#6a737d cterm=reverse
hi Comment guifg=#6a737d cterm=reverse
hi String guifg=#9ecbff cterm=reverse
hi Number guifg=#9ecbff cterm=reverse
hi Special guifg=#79b8ff term=reverse
hi Constant guifg=#79b8ff cterm=reverse
hi Operator guifg=#f97583 cterm=reverse
hi Type guifg=#b392f0 gui=italic cterm=italic,reverse
hi Function guifg=#cea5fb cterm=reverse
hi Statement guifg=#f97583 cterm=reverse
hi PreProc guifg=#f97583 cterm=reverse
hi StatusLine guibg=#ffffff guifg=#000000 gui=bold cterm=reverse,bold
hi LineNr guifg=#444d56 cterm=reverse
hi CursorLine guibg=#2b3036 cterm=reverse
hi CursorLineNr cterm=NONE guifg=#e1e4e8 guibg=#2b3036 cterm=reverse
hi Visual guifg=NONE guibg=#282e34 gui=reverse cterm=reverse
