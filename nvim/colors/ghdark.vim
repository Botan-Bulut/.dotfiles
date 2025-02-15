set background=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "github_dark_classic"

hi Normal guibg=#000000 guifg=#d1d5da cterm=reverse
hi NonText guifg=#6a737d cterm=reverse
hi Comment guifg=#6a737d cterm=reverse
hi String guifg=#9ecbff cterm=reverse
hi Number guifg=#fa7970 cterm=reverse
hi Special guifg=#79b8ff cterm=reverse
hi Constant guifg=#79b8ff cterm=reverse
hi Operator guifg=#f97583 cterm=reverse
hi Type guifg=#b392f0 gui=italic cterm=italic,reverse
hi Function guifg=#cea5fb gui=bold cterm=bold,reverse
hi Statement guifg=#f97583 cterm=reverse
hi PreProc guifg=#f97583 cterm=reverse
hi StatusLine guibg=#1f2428 guifg=#e1e4e8 gui=bold cterm=bold,reverse
hi LineNr guifg=#444d56 cterm=reverse
hi CursorLine guibg=#2b3036 cterm=reverse
hi CursorLineNr cterm=NONE guifg=#e1e4e8 guibg=#2b3036 cterm=reverse
hi Visual guifg=NONE guibg=#282e34 gui=reverse cterm=reverse
hi VisualNOS guifg=NONE guibg=#282e34 gui=bold,underline cterm=underline,reverse

" Token colors
hi Comment guifg=#6a737d
hi Constant guifg=#79b8ff
hi Entity guifg=#b392f0
hi Variable guifg=#e1e4e8
hi Keyword guifg=#f97583
hi Storage guifg=#f97583
hi StorageModifier guifg=#e1e4e8
hi String guifg=#9ecbff
hi Support guifg=#79b8ff
hi MetaPropertyName guifg=#79b8ff
hi Invalid guifg=#fdaeb7 gui=italic
hi MessageError guifg=#fdaeb7
hi DiffInserted guibg=#144620 guifg=#85e89d
hi DiffRemoved guibg=#86181d guifg=#fdaeb7
hi DiffChanged guibg=#c24e00 guifg=#ffab70

" UI elements colors
hi StatusBar guibg=#24292e guifg=#e1e4e8
hi TabLine guibg=#1f2428 guifg=#959da5
hi TabLineFill guibg=#1f2428
hi TabLineSel guibg=#24292e guifg=#e1e4e8
hi TitleBar guibg=#24292e guifg=#e1e4e8

" Buttons and Dropdowns
hi Button guibg=#176f2c guifg=#dcffe4
hi ButtonHover guibg=#22863a
hi Dropdown guibg=#2f363d guifg=#e1e4e8
hi Input guibg=#2f363d guifg=#e1e4e8

" Notifications
hi NotificationCenter guibg=#2f363d guifg=#e1e4e8
hi NotificationCenterHeader guibg=#24292e guifg=#959da5
hi Notification guibg=#2f363d guifg=#e1e4e8
