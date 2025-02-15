set background=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "github_dark"

hi Normal guibg=#000000 guifg=#C9D1D9 cterm=reverse
hi NonText guifg=#6A737D cterm=reverse
hi comment guifg=#6A737D cterm=reverse
hi string guifg=#77bdfb cterm=reverse
hi number guifg=#F9A826 cterm=reverse
hi special guifg=#F9A826 cterm=reverse
hi constant guifg=#F9A826 cterm=reverse
hi operator guifg=#D73A49 cterm=reverse
hi type guifg=#79C0FF gui=italic cterm=italic,reverse
hi Function guifg=#58A6FF gui=bold cterm=bold,reverse
hi statement guifg=#D73A49 cterm=reverse
hi preproc guifg=#D73A49 cterm=reverse
hi StatusLine guibg=#1F2329 guifg=#C9D1D9 gui=bold cterm=bold,reverse
hi LineNr guifg=#6A737D cterm=reverse
hi CursorLine guibg=#2D333B cterm=reverse
hi CursorLineNr cterm=NONE guifg=#6A737D guibg=#2D333B cterm=reverse
hi Visual guifg=NONE guibg=#57606A gui=reverse cterm=reverse
hi VisualNOS guifg=NONE guibg=#57606A gui=bold,underline cterm=underline,reverse
