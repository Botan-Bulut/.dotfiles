set background=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "vimsub"

hi Normal guibg=#000000
hi NonText guifg=#FF604F
hi comment guifg=#74705D
hi string guifg=#E7DB74
hi number guifg=#AC80FF
hi special guifg=#AC80FF
hi constant guifg=#AC80FF
hi operator guifg=#F92472
hi type guifg=#67D8EF gui=italic cterm=italic
hi Function guifg=#A6E22A gui=bold cterm=bold
hi statement guifg=#F92472
hi preproc guifg=#F92472
hi StatusLine guibg=#ffffff guifg=#000000 gui=bold cterm=bold
hi LineNr guifg=#90918B
hi CursorLine guibg=#303030
hi CursorLineNr cterm=NONE guifg=#90918B guibg=#3E3D32
hi Visual guifg=NONE guibg=#000000 gui=reverse cterm=reverse
hi VisualNOS guifg=NONE guibg=#000000 gui=bold,underline cterm=underline
