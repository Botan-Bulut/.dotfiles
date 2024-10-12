set background=dark
hi clear


if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "solarized-custom"

" Directly applying hex values
hi Normal       guibg=#002B36 guifg=#839496
hi NonText      guifg=#586e75
hi Comment      guifg=#586e75
hi String       guifg=#2aa198
hi Number       guifg=#6c71c4
hi Special      guifg=#cb4b16 gui=bold               
hi Constant     guifg=#6c71c4               
hi Operator     guifg=#cb4b16 
hi Type         guifg=#b58900 gui=italic cterm=italic
hi Function     guifg=#719e07 gui=bold cterm=bold
hi Keyword      guifg=#cb4b16 gui=bold
hi Statement    guifg=#cb4b16 gui=bold
hi PreProc      guifg=#cb4b16 gui=bold
hi StatusLine   guifg=#839496 guibg=#073642
hi LineNr       guifg=#586e75
hi CursorLine   guibg=#283235 guifg=NONE
hi CursorLineNr guifg=#657b83 guibg=#002732
hi Visual       guibg=#000000 gui=reverse cterm=reverse
hi VisualNOS    guibg=#000000 gui=bold,underline cterm=underline
hi Identifier guifg=#719e07 gui=bold
hi MatchParen cterm=reverse ctermbg=NONE ctermfg=NONE guibg=NONE guifg=#ffffff
hi Cursor guibg=NONE guifg=#000000
hi Pmenu ctermfg=White ctermbg=Blue guifg=White guibg=Blue
