" Vim syntax file
" Language:     C
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last Change:  2007 Jan 16

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" A bunch of useful C keywords
syn keyword     cStatement      goto break return continue asm
syn keyword     cLabel          case default
syn keyword     cConditional    if else switch
syn keyword     cRepeat         while for do

" Added 2006-05-25 by Gautam Iyer <gi1242@users.sourceforge.net>
" Highlighting of C library functions.
if exists( 'c_hi_identifiers' )
    " Highlight functions / variables defined in standard C libraries

    " Don't look for library identifiers / functions following a '.', '->'
    " or 'struct'.
    syn cluster cLibIdentifiers         contains=cLibFunction,cLibVariable
    syn match cGenericIdentifier        transparent contains=@cLibIdentifiers '\v%(%(\.|-\>|<struct>)\s*)@<!<\I\i*>'

    if c_hi_identifiers =~ '\v\C<generic_functions>'
        " Match anything that looks like a generic function call
        syn match cGenericFunction      containedin=cGenericIdentifier '\v\I\i*\ze\s*\('
    endif

    " Match functions / constants from specific libraries. Check global and
    " buffer local variables for a list of library patterns to load.
    if exists( 'g:c_hi_libs' ) || exists( 'b:c_hi_libs' )
        let s:libs = exists( 'b:c_hi_libs' ) ? b:c_hi_libs : g:c_hi_libs

        for s:lib in s:libs
            exec 'runtime! syntax/clibs/'. s:lib . '.vim'
        endfor
        unlet s:lib s:libs
    endif
endif


syn keyword     cTodo           contained TODO FIXME XXX

" cCommentGroup allows adding matches for special things in comments
syn cluster     cCommentGroup   contains=cTodo

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match       cSpecial        display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("c_no_utf")
  syn match     cSpecial        display contained "\\\(u\x\{4}\|U\x\{8}\)"
endif
if exists("c_no_cformat")
  syn region    cString         start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,@Spell
  " cCppString: same as cString, but ends at end of line
  syn region    cCppString      start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial,@Spell
else
  if !exists("c_no_c99") " ISO C99
    syn match   cFormat         display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjzt]\|ll\|hh\)\=\([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  else
    syn match   cFormat         display "%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([bdiuoxXDOUfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  endif
  syn match     cFormat         display "%%" contained
  syn region    cString         start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=cSpecial,cFormat,@Spell
  " cCppString: same as cString, but ends at end of line
  syn region    cCppString      start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial,cFormat,@Spell
endif

syn match       cCharacter      "L\='[^\\]'"
syn match       cCharacter      "L'[^']*'" contains=cSpecial
if exists("c_gnu")
  syn match     cSpecialError   "L\='\\[^'\"?\\abefnrtv]'"
  syn match     cSpecialCharacter "L\='\\['\"?\\abefnrtv]'"
else
  syn match     cSpecialError   "L\='\\[^'\"?\\abfnrtv]'"
  syn match     cSpecialCharacter "L\='\\['\"?\\abfnrtv]'"
endif
syn match       cSpecialCharacter display "L\='\\\o\{1,3}'"
syn match       cSpecialCharacter display "'\\x\x\{1,2}'"
syn match       cSpecialCharacter display "L'\\x\x\+'"

"when wanted, highlight trailing white space
if exists("c_space_errors")
  if !exists("c_no_trail_space_error")
    syn match   cSpaceError     display excludenl "\s\+$"
  endif
  if !exists("c_no_tab_space_error")
    syn match   cSpaceError     display " \+\t"me=e-1
  endif
endif

" This should be before cErrInParen to avoid problems with #define ({ xxx })
syntax region   cBlock          start="{" end="}" transparent fold

"catch errors caused by wrong parenthesis and brackets
" also accept <% for {, %> for }, <: for [ and :> for ] (C99)
" But avoid matching <::.
syn cluster     cParenGroup     contains=cParenError,cIncluded,cSpecial,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cUserCont,cUserLabel,cBitField,cCommentSkip,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom
if exists("c_no_curly_error")
  syn region    cParen          transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region    cCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,cString,@Spell
  syn match     cParenError     display ")"
  syn match     cErrInParen     display contained "^[{}]\|^<%\|^%>"
elseif exists("c_no_bracket_error")
  syn region    cParen          transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region    cCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cParen,cString,@Spell
  syn match     cParenError     display ")"
  syn match     cErrInParen     display contained "[{}]\|<%\|%>"
else
  syn region    cParen          transparent start='(' end=')' contains=ALLBUT,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,cCppString,@Spell
  " cCppParen: same as cParen but ends at end-of-line; used in cDefine
  syn region    cCppParen       transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@cParenGroup,cErrInBracket,cParen,cBracket,cString,@Spell
  syn match     cParenError     display "[\])]"
  syn match     cErrInParen     display contained "[\]{}]\|<%\|%>"
  syn region    cBracket        transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@cParenGroup,cErrInParen,cCppParen,cCppBracket,cCppString,@Spell
  " cCppBracket: same as cParen but ends at end-of-line; used in cDefine
  syn region    cCppBracket     transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@cParenGroup,cErrInParen,cParen,cBracket,cString,@Spell
  syn match     cErrInBracket   display contained "[);{}]\|<%\|%>"
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match       cNumbers        display transparent "\<\d\|\.\d" contains=cNumber,cFloat,cOctalError,cOctal
" Same, but without octals (for comments)
syn match       cNumbersCom     display contained transparent "\<\d\|\.\d" contains=cNumber,cFloat
syn match       cNumber         display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"hex number
syn match       cNumber         display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
" Flag the first zero of an octal number as something special
syn match       cOctal          display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=cOctalZero
syn match       cOctalZero      display contained "\<0"
syn match       cFloat          display contained "\d\+f"
"floating point number, with dot, optional exponent
syn match       cFloat          display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match       cFloat          display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match       cFloat          display contained "\d\+e[-+]\=\d\+[fl]\=\>"
if !exists("c_no_c99")
  "hexadecimal floating point number, optional leading digits, with dot, with exponent
  syn match     cFloat          display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"
  "hexadecimal floating point number, with leading digits, optional dot, with exponent
  syn match     cFloat          display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"
endif

" flag an octal number with wrong digits
syn match       cOctalError     display contained "0\o*[89]\d*"
syn case match

if exists("c_comment_strings")
  " A comment can contain cString, cCharacter and cNumber.
  " But a "*/" inside a cString in a cComment DOES end the comment!  So we
  " need to use a special type of cString: cCommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syntax match  cCommentSkip    contained "^\s*\*\($\|\s\+\)"
  syntax region cCommentString  contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=cSpecial,cCommentSkip
  syntax region cComment2String contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=cSpecial
  syntax region  cCommentL      start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cComment2String,cCharacter,cNumbersCom,cSpaceError,@Spell
  if exists("c_no_comment_fold")
    syntax region cComment      matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell
  else
    syntax region cComment      matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cCommentString,cCharacter,cNumbersCom,cSpaceError,@Spell fold
  endif
else
  syn region    cCommentL       start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cSpaceError,@Spell
  if exists("c_no_comment_fold")
    syn region  cComment        matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell
  else
    syn region  cComment        matchgroup=cCommentStart start="/\*" end="\*/" contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell fold
  endif
endif
" keep a // comment separately, it terminates a preproc. conditional
syntax match    cCommentError   display "\*/"
syntax match    cCommentStartError display "/\*"me=e-1 contained

syn keyword     cOperator       sizeof
if exists("c_gnu")
  syn keyword   cStatement      __asm__
  syn keyword   cOperator       typeof __real__ __imag__
endif
syn keyword     cType           int long short char void
syn keyword     cType           signed unsigned float double
if !exists("c_no_ansi") || exists("c_ansi_typedefs")
  syn keyword   cType           size_t ssize_t wchar_t ptrdiff_t sig_atomic_t fpos_t
  syn keyword   cType           clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t
  syn keyword   cType           mbstate_t wctrans_t wint_t wctype_t
endif
if !exists("c_no_c99") " ISO C99
  syn keyword   cType           bool complex
  syn keyword   cType           int8_t int16_t int32_t int64_t
  syn keyword   cType           uint8_t uint16_t uint32_t uint64_t
  syn keyword   cType           int_least8_t int_least16_t int_least32_t int_least64_t
  syn keyword   cType           uint_least8_t uint_least16_t uint_least32_t uint_least64_t
  syn keyword   cType           int_fast8_t int_fast16_t int_fast32_t int_fast64_t
  syn keyword   cType           uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
  syn keyword   cType           intptr_t uintptr_t
  syn keyword   cType           intmax_t uintmax_t
endif
if exists("c_gnu")
  syn keyword   cType           __label__ __complex__ __volatile__
endif

syn keyword     cStructure      struct union enum typedef
syn keyword     cStorageClass   static register auto volatile extern const
if exists("c_gnu")
  syn keyword   cStorageClass   inline __attribute__
endif
if !exists("c_no_c99")
  syn keyword   cStorageClass   inline restrict
endif

if !exists("c_no_ansi") || exists("c_ansi_constants") || exists("c_gnu")
  if exists("c_gnu")
    syn keyword cConstant __GNUC__ __FUNCTION__ __PRETTY_FUNCTION__ __func__
  endif
  syn keyword cConstant __LINE__ __FILE__ __DATE__ __TIME__ __STDC__
  syn keyword cConstant __STDC_VERSION__
  if !exists('c_hi_identifiers') " Defined in clibs/glibc.vim
  syn keyword cConstant CHAR_BIT MB_LEN_MAX MB_CUR_MAX
  syn keyword cConstant UCHAR_MAX UINT_MAX ULONG_MAX USHRT_MAX
  syn keyword cConstant CHAR_MIN INT_MIN LONG_MIN SHRT_MIN
  syn keyword cConstant CHAR_MAX INT_MAX LONG_MAX SHRT_MAX
  syn keyword cConstant SCHAR_MIN SINT_MIN SLONG_MIN SSHRT_MIN
  syn keyword cConstant SCHAR_MAX SINT_MAX SLONG_MAX SSHRT_MAX
  endif
  if !exists("c_no_c99")
    syn keyword cConstant __func__
    syn keyword cConstant LLONG_MAX ULLONG_MAX
    syn keyword cConstant INT8_MIN INT16_MIN INT32_MIN INT64_MIN
    syn keyword cConstant INT8_MAX INT16_MAX INT32_MAX INT64_MAX
    syn keyword cConstant UINT8_MAX UINT16_MAX UINT32_MAX UINT64_MAX
    syn keyword cConstant INT_LEAST8_MIN INT_LEAST16_MIN INT_LEAST32_MIN INT_LEAST64_MIN
    syn keyword cConstant INT_LEAST8_MAX INT_LEAST16_MAX INT_LEAST32_MAX INT_LEAST64_MAX
    syn keyword cConstant UINT_LEAST8_MAX UINT_LEAST16_MAX UINT_LEAST32_MAX UINT_LEAST64_MAX
    syn keyword cConstant INT_FAST8_MIN INT_FAST16_MIN INT_FAST32_MIN INT_FAST64_MIN
    syn keyword cConstant INT_FAST8_MAX INT_FAST16_MAX INT_FAST32_MAX INT_FAST64_MAX
    syn keyword cConstant UINT_FAST8_MAX UINT_FAST16_MAX UINT_FAST32_MAX UINT_FAST64_MAX
    syn keyword cConstant INTPTR_MIN INTPTR_MAX UINTPTR_MAX
    syn keyword cConstant INTMAX_MIN INTMAX_MAX UINTMAX_MAX
    syn keyword cConstant PTRDIFF_MIN PTRDIFF_MAX SIG_ATOMIC_MIN SIG_ATOMIC_MAX
    syn keyword cConstant SIZE_MAX WCHAR_MIN WCHAR_MAX WINT_MIN WINT_MAX
  endif
  if !exists('c_hi_identifiers') " Defined in clibs/glibc.vim
  syn keyword cConstant FLT_RADIX FLT_ROUNDS
  syn keyword cConstant FLT_DIG FLT_MANT_DIG FLT_EPSILON
  syn keyword cConstant DBL_DIG DBL_MANT_DIG DBL_EPSILON
  syn keyword cConstant LDBL_DIG LDBL_MANT_DIG LDBL_EPSILON
  syn keyword cConstant FLT_MIN FLT_MAX FLT_MIN_EXP FLT_MAX_EXP
  syn keyword cConstant FLT_MIN_10_EXP FLT_MAX_10_EXP
  syn keyword cConstant DBL_MIN DBL_MAX DBL_MIN_EXP DBL_MAX_EXP
  syn keyword cConstant DBL_MIN_10_EXP DBL_MAX_10_EXP
  syn keyword cConstant LDBL_MIN LDBL_MAX LDBL_MIN_EXP LDBL_MAX_EXP
  syn keyword cConstant LDBL_MIN_10_EXP LDBL_MAX_10_EXP
  syn keyword cConstant HUGE_VAL CLOCKS_PER_SEC NULL
  syn keyword cConstant LC_ALL LC_COLLATE LC_CTYPE LC_MONETARY
  syn keyword cConstant LC_NUMERIC LC_TIME
  syn keyword cConstant SIG_DFL SIG_ERR SIG_IGN
  syn keyword cConstant SIGABRT SIGFPE SIGILL SIGHUP SIGINT SIGSEGV SIGTERM
  " Add POSIX signals as well...
  syn keyword cConstant SIGABRT SIGALRM SIGCHLD SIGCONT SIGFPE SIGHUP
  syn keyword cConstant SIGILL SIGINT SIGKILL SIGPIPE SIGQUIT SIGSEGV
  syn keyword cConstant SIGSTOP SIGTERM SIGTRAP SIGTSTP SIGTTIN SIGTTOU
  syn keyword cConstant SIGUSR1 SIGUSR2
  syn keyword cConstant _IOFBF _IOLBF _IONBF BUFSIZ EOF WEOF
  syn keyword cConstant FOPEN_MAX FILENAME_MAX L_tmpnam
  syn keyword cConstant SEEK_CUR SEEK_END SEEK_SET
  syn keyword cConstant TMP_MAX stderr stdin stdout
  syn keyword cConstant EXIT_FAILURE EXIT_SUCCESS RAND_MAX
  " Add POSIX errors as well
  syn keyword cConstant E2BIG EACCES EAGAIN EBADF EBADMSG EBUSY
  syn keyword cConstant ECANCELED ECHILD EDEADLK EDOM EEXIST EFAULT
  syn keyword cConstant EFBIG EILSEQ EINPROGRESS EINTR EINVAL EIO EISDIR
  syn keyword cConstant EMFILE EMLINK EMSGSIZE ENAMETOOLONG ENFILE ENODEV
  syn keyword cConstant ENOENT ENOEXEC ENOLCK ENOMEM ENOSPC ENOSYS
  syn keyword cConstant ENOTDIR ENOTEMPTY ENOTSUP ENOTTY ENXIO EPERM
  syn keyword cConstant EPIPE ERANGE EROFS ESPIPE ESRCH ETIMEDOUT EXDEV
  " math.h
  syn keyword cConstant M_E M_LOG2E M_LOG10E M_LN2 M_LN10 M_PI M_PI_2 M_PI_4
  syn keyword cConstant M_1_PI M_2_PI M_2_SQRTPI M_SQRT2 M_SQRT1_2
  endif
endif
if !exists("c_no_c99") " ISO C99
  syn keyword cConstant true false
endif

" Accept %: for # (C99)
syn region      cPreCondit      start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=cComment,cCppString,cCharacter,cCppParen,cParenError,cNumbers,cCommentError,cSpaceError
syn match       cPreCondit      display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
if !exists("c_no_if0")
  if !exists("c_no_if0_fold")
    syn region  cCppOut         start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=cCppOut2 fold
  else
    syn region  cCppOut         start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=cCppOut2
  endif
  syn region    cCppOut2        contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=cSpaceError,cCppSkip
  syn region    cCppSkip        contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=cSpaceError,cCppSkip
endif
syn region      cIncluded       display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match       cIncluded       display contained "<[^>]*>"
syn match       cInclude        display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded
"syn match cLineSkip    "\\$"
syn cluster     cPreProcGroup   contains=cPreCondit,cIncluded,cInclude,cDefine,cErrInParen,cErrInBracket,cUserLabel,cSpecial,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom,cString,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cParen,cBracket,cMulti
syn region      cDefine         start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$" end="//"me=s-1 keepend contains=ALLBUT,@cPreProcGroup,@Spell
syn region      cPreProc        start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@cPreProcGroup,@Spell

" Highlight User Labels
syn cluster     cMultiGroup     contains=cIncluded,cSpecial,cCommentSkip,cCommentString,cComment2String,@cCommentGroup,cCommentStartError,cUserCont,cUserLabel,cBitField,cOctalZero,cCppOut,cCppOut2,cCppSkip,cFormat,cNumber,cFloat,cOctal,cOctalError,cNumbersCom,cCppParen,cCppBracket,cCppString
syn region      cMulti          transparent start='?' skip='::' end=':' contains=ALLBUT,@cMultiGroup,@Spell
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster     cLabelGroup     contains=cUserLabel
syn match       cUserCont       display "^\s*\I\i*\s*:$" contains=@cLabelGroup
syn match       cUserCont       display ";\s*\I\i*\s*:$" contains=@cLabelGroup
syn match       cUserCont       display "^\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup
syn match       cUserCont       display ";\s*\I\i*\s*:[^:]"me=e-1 contains=@cLabelGroup

syn match       cUserLabel      display "\I\i*" contained

" Avoid recognizing most bitfields as labels
syn match       cBitField       display "^\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=cType
syn match       cBitField       display ";\s*\I\i*\s*:\s*[1-9]"me=e-1 contains=cType

if exists("c_minlines")
  let b:c_minlines = c_minlines
else
  if !exists("c_no_if0")
    let b:c_minlines = 50       " #if 0 constructs can be long
  else
    let b:c_minlines = 15       " mostly for () constructs
  endif
endif
exec "syn sync ccomment cComment minlines=" . b:c_minlines

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link cFormat             cSpecial
hi def link cCppString          cString
hi def link cCommentL           cComment
hi def link cCommentStart       cComment
hi def link cLabel              Label
hi def link cUserLabel          Label
hi def link cConditional        Conditional
hi def link cRepeat             Repeat
hi def link cCharacter          Character
hi def link cSpecialCharacter   cSpecial
hi def link cNumber             Number
hi def link cOctal              Number
hi def link cOctalZero          PreProc  " link this to Error if you want
hi def link cFloat              Float
hi def link cOctalError         cError
hi def link cParenError         cError
hi def link cErrInParen         cError
hi def link cErrInBracket       cError
hi def link cCommentError       cError
hi def link cCommentStartError  cError
hi def link cSpaceError         cError
hi def link cSpecialError       cError
hi def link cOperator           Operator
hi def link cStructure          Structure
hi def link cStorageClass       StorageClass
hi def link cInclude            Include
hi def link cPreProc            PreProc
hi def link cDefine             Macro
hi def link cIncluded           cString
hi def link cError              Error
hi def link cStatement          Statement
hi def link cPreCondit          PreCondit
hi def link cType               Type
hi def link cConstant           Constant
hi def link cCommentString      cString
hi def link cComment2String     cString
hi def link cCommentSkip        cComment
hi def link cString             String
hi def link cComment            Comment
hi def link cSpecial            SpecialChar
hi def link cTodo               Todo
hi def link cCppSkip            cCppOut
hi def link cCppOut2            cCppOut
hi def link cCppOut             Comment

hi def link cGenericFunction    Function
hi def link cLibFunction        Function
hi def link cLibVariable        Constant

" clibs/xlib.vim: Syntax file to match identifiers from Xlib
" Created:      Thu 25 May 2006 06:27:55 PM CDT
" Modified:     Thu 22 Feb 2007 01:10:28 AM PST
" Author:       Gautam Iyer <gi1242@users.sourceforge.net>
"
" DESCRIPTION
"
"   Matches the standard functions defined by xlib. This file is meant to be
"   included from whatever file wants to match these items (the including file
"   must provide the cLibIdentifiers syntax cluster).
"
" No need to provide load control using b:current_syntax, as this file is only
" meant to be included from the C syntax file. However if "c_hi_identifiers"
" is not defined, we define no syntax items so we exit right away and define
" no syntax items.
if !exists( 'c_hi_identifiers' )
    finish
endif

" Standard X library functions (no extensions)
if c_hi_identifiers =~ '\v\C<(all|functions)>'
    " {{{ Xlib functions [generated from /usr/include/X11/Xlib.h]
    syn keyword cLibFunction contained  XActivateScreenSaver XAddConnectionWatch XAddExtension XAddHost XAddHosts XAddToExtensionList XAddToSaveSet XAllPlanes XAllocColor XAllocColorCells XAllocColorPlanes XAllocNamedColor XAllowEvents XAutoRepeatOff XAutoRepeatOn
    syn keyword cLibFunction contained  XBaseFontNameListOfFontSet XBell XBitmapBitOrder XBitmapPad XBitmapUnit XBlackPixel XBlackPixelOfScreen
    syn keyword cLibFunction contained  XCellsOfScreen XChangeActivePointerGrab XChangeGC XChangeKeyboardControl XChangeKeyboardMapping XChangePointerControl XChangeProperty XChangeSaveSet XChangeWindowAttributes XCheckIfEvent XCheckMaskEvent XCheckTypedEvent XCheckTypedWindowEvent XCheckWindowEvent XCirculateSubwindows XCirculateSubwindowsDown XCirculateSubwindowsUp XClearArea XClearWindow XCloseDisplay XCloseIM XCloseOM XConfigureWindow XConnectionNumber XContextDependentDrawing XContextualDrawing XConvertSelection XCopyArea XCopyColormapAndFree XCopyGC XCopyPlane XCreateBitmapFromData XCreateColormap XCreateFontCursor XCreateFontSet XCreateGC XCreateGlyphCursor XCreateIC XCreateImage XCreateOC XCreatePixmap XCreatePixmapCursor XCreatePixmapFromBitmapData XCreateSimpleWindow XCreateWindow
    syn keyword cLibFunction contained  XDefaultColormap XDefaultColormapOfScreen XDefaultDepth XDefaultDepthOfScreen XDefaultGC XDefaultGCOfScreen XDefaultRootWindow XDefaultScreen XDefaultScreenOfDisplay XDefaultVisual XDefaultVisualOfScreen XDefineCursor XDeleteModifiermapEntry XDeleteProperty XDestroyIC XDestroyOC XDestroySubwindows XDestroyWindow XDirectionalDependentDrawing XDisableAccessControl XDisplayCells XDisplayHeight XDisplayHeightMM XDisplayKeycodes XDisplayMotionBufferSize XDisplayName XDisplayOfIM XDisplayOfOM XDisplayOfScreen XDisplayPlanes XDisplayString XDisplayWidth XDisplayWidthMM XDoesBackingStore XDoesSaveUnders XDrawArc XDrawArcs XDrawImageString XDrawImageString16 XDrawLine XDrawLines XDrawPoint XDrawPoints XDrawRectangle XDrawRectangles XDrawSegments XDrawString XDrawString16 XDrawText XDrawText16
    syn keyword cLibFunction contained  XEHeadOfExtensionList XEnableAccessControl XEventMaskOfScreen XEventsQueued XExtendedMaxRequestSize XExtentsOfFontSet
    syn keyword cLibFunction contained  XFetchBuffer XFetchBytes XFetchName XFillArc XFillArcs XFillPolygon XFillRectangle XFillRectangles XFilterEvent XFindOnExtensionList XFlush XFlushGC XFontsOfFontSet XForceScreenSaver XFree XFreeColormap XFreeColors XFreeCursor XFreeExtensionList XFreeFont XFreeFontInfo XFreeFontNames XFreeFontPath XFreeFontSet XFreeGC XFreeModifiermap XFreePixmap XFreeStringList
    syn keyword cLibFunction contained  XGContextFromGC XGeometry XGetAtomName XGetAtomNames XGetCommand XGetDefault XGetErrorDatabaseText XGetErrorText XGetFontPath XGetFontProperty XGetGCValues XGetGeometry XGetICValues XGetIMValues XGetIconName XGetImage XGetInputFocus XGetKeyboardControl XGetKeyboardMapping XGetModifierMapping XGetMotionEvents XGetOCValues XGetOMValues XGetPointerControl XGetPointerMapping XGetScreenSaver XGetSelectionOwner XGetSubImage XGetTransientForHint XGetWMColormapWindows XGetWMProtocols XGetWindowAttributes XGetWindowProperty XGrabButton XGrabKey XGrabKeyboard XGrabPointer XGrabServer
    syn keyword cLibFunction contained  XHeightMMOfScreen XHeightOfScreen
    syn keyword cLibFunction contained  XIMOfIC XIconifyWindow XIfEvent XImageByteOrder XInitExtension XInitImage XInitThreads XInsertModifiermapEntry XInstallColormap XInternAtom XInternAtoms XInternalConnectionNumbers
    syn keyword cLibFunction contained  XKeycodeToKeysym XKeysymToKeycode XKeysymToString XKillClient
    syn keyword cLibFunction contained  XLastKnownRequestProcessed XListDepths XListExtensions XListFonts XListFontsWithInfo XListHosts XListInstalledColormaps XListPixmapFormats XListProperties XLoadFont XLoadQueryFont XLocaleOfFontSet XLocaleOfIM XLocaleOfOM XLockDisplay XLookupColor XLookupKeysym XLowerWindow
    syn keyword cLibFunction contained  XMapRaised XMapSubwindows XMapWindow XMaskEvent XMaxCmapsOfScreen XMaxRequestSize XMinCmapsOfScreen XMoveResizeWindow XMoveWindow
    syn keyword cLibFunction contained  XNewModifiermap XNextEvent XNextRequest XNoOp
    syn keyword cLibFunction contained  XOMOfOC XOpenDisplay XOpenIM XOpenOM
    syn keyword cLibFunction contained  XParseColor XParseGeometry XPeekEvent XPeekIfEvent XPending XPlanesOfScreen XProcessInternalConnection XProtocolRevision XProtocolVersion XPutBackEvent XPutImage
    syn keyword cLibFunction contained  XQLength XQueryBestCursor XQueryBestSize XQueryBestStipple XQueryBestTile XQueryColor XQueryColors XQueryExtension XQueryFont XQueryKeymap XQueryPointer XQueryTextExtents XQueryTextExtents16 XQueryTree
    syn keyword cLibFunction contained  XRaiseWindow XReadBitmapFile XReadBitmapFileData XRebindKeysym XRecolorCursor XReconfigureWMWindow XRefreshKeyboardMapping XRegisterIMInstantiateCallback XRemoveConnectionWatch XRemoveFromSaveSet XRemoveHost XRemoveHosts XReparentWindow XResetScreenSaver XResizeWindow XResourceManagerString XRestackWindows XRootWindow XRootWindowOfScreen XRotateBuffers XRotateWindowProperties
    syn keyword cLibFunction contained  XScreenCount XScreenNumberOfScreen XScreenOfDisplay XScreenResourceString XSelectInput XSendEvent XServerVendor XSetAccessControl XSetAfterFunction XSetArcMode XSetAuthorization XSetBackground XSetClipMask XSetClipOrigin XSetClipRectangles XSetCloseDownMode XSetCommand XSetDashes XSetErrorHandler XSetFillRule XSetFillStyle XSetFont XSetFontPath XSetForeground XSetFunction XSetGraphicsExposures XSetICFocus XSetICValues XSetIMValues XSetIOErrorHandler XSetIconName XSetInputFocus XSetLineAttributes XSetLocaleModifiers XSetModifierMapping XSetOCValues XSetOMValues XSetPlaneMask XSetPointerMapping XSetScreenSaver XSetSelectionOwner XSetState XSetStipple XSetSubwindowMode XSetTSOrigin XSetTile XSetTransientForHint XSetWMColormapWindows XSetWMProtocols XSetWindowBackground XSetWindowBackgroundPixmap XSetWindowBorder XSetWindowBorderPixmap XSetWindowBorderWidth XSetWindowColormap XStoreBuffer XStoreBytes XStoreColor XStoreColors XStoreName XStoreNamedColor XStringToKeysym XSupportsLocale XSync XSynchronize
    syn keyword cLibFunction contained  XTextExtents XTextExtents16 XTextWidth XTextWidth16 XTranslateCoordinates
    syn keyword cLibFunction contained  XUndefineCursor XUngrabButton XUngrabKey XUngrabKeyboard XUngrabPointer XUngrabServer XUninstallColormap XUnloadFont XUnlockDisplay XUnmapSubwindows XUnmapWindow XUnregisterIMInstantiateCallback XUnsetICFocus
    syn keyword cLibFunction contained  XVaCreateNestedList XVendorRelease XVisualIDFromVisual
    syn keyword cLibFunction contained  XWarpPointer XWhitePixel XWhitePixelOfScreen XWidthMMOfScreen XWidthOfScreen XWindowEvent XWithdrawWindow XWriteBitmapFile
    syn keyword cLibFunction contained  XmbDrawImageString XmbDrawString XmbDrawText XmbLookupString XmbResetIC XmbTextEscapement XmbTextExtents XmbTextPerCharExtents XrmInitialize Xutf8DrawImageString Xutf8DrawString Xutf8DrawText Xutf8LookupString Xutf8ResetIC Xutf8TextEscapement Xutf8TextExtents Xutf8TextPerCharExtents XwcDrawImageString XwcDrawString XwcDrawText XwcLookupString XwcResetIC XwcTextEscapement XwcTextExtents XwcTextPerCharExtents _Xmblen _Xmbtowc _Xwctomb
    " }}}
endif

" TODO: Match xlib constants. Is there a good list somewhere?

" clibs/glibc.vim: Syntax file to match identifiers from glibc
" Created:      Thu 25 May 2006 06:27:55 PM CDT
" Modified:     Thu 22 Feb 2007 01:08:24 AM PST
" Author:       Gautam Iyer <gi1242@users.sourceforge.net>
"
" DESCRIPTION
"
"   Matches the standard functions defined by glibc. This file is meant to be
"   included from whatever file wants to match these items (the including file
"   must provide the cLibIdentifiers syntax cluster).
"
" No need to provide load control using b:current_syntax, as this file is only
" meant to be included from the C syntax file. However if "c_hi_identifiers"
" is not defined, we define no syntax items so we exit right away and define
" no syntax items.
if !exists( 'c_hi_identifiers' )
    finish
endif

" Functions. [generated from "info libc 'Function Index'"]
if c_hi_identifiers =~ '\v\C<(functions|all)>'
    " {{{ glibc functions
    syn keyword cLibFunction contained   CPU_CLR CPU_ISSET CPU_SET CPU_ZERO DES_FAILED DTTOIF FD_CLR FD_ISSET FD_SET FD_ZERO IFTODT SUN_LEN S_ISBLK S_ISCHR S_ISDIR S_ISFIFO S_ISLNK S_ISREG S_ISSOCK S_TYPEISMQ S_TYPEISSEM S_TYPEISSHM TEMP_FAILURE_RETRY WCOREDUMP WEXITSTATUS WIFEXITED WIFSIGNALED WIFSTOPPED WSTOPSIG WTERMSIG _Exit __fbufsize __flbf __fpending __fpurge __freadable __freading __fsetlocking __fwritable __fwriting __va_copy _exit _flushlbf _tolower _toupper
    syn keyword cLibFunction contained   a64l abort abs accept access acos acosf acosh acoshf acoshl acosl addmntent addseverity adjtime adjtimex aio_cancel aio_cancel64 aio_error aio_error64 aio_fsync aio_fsync64 aio_init aio_read aio_read64 aio_return aio_return64 aio_suspend aio_suspend64 aio_write aio_write64 alarm alloca alphasort alphasort64 argp_error argp_failure argp_help argp_parse argp_state_help argp_usage argz_add argz_add_sep argz_append argz_count argz_create argz_create_sep argz_delete argz_extract argz_insert argz_next argz_replace argz_stringify asctime asctime_r asin asinf asinh asinhf asinhl asinl asprintf assert assert_perror atan atan2 atan2f atan2l atanf atanh atanhf atanhl atanl atexit atof atoi atol atoll
    syn keyword cLibFunction contained   backtrace backtrace_symbols backtrace_symbols_fd basename bcmp bcopy bind bind_textdomain_codeset bindtextdomain brk bsearch btowc bzero
    syn keyword cLibFunction contained   cabs cabsf cabsl cacos cacosf cacosh cacoshf cacoshl cacosl calloc canonicalize_file_name carg cargf cargl casin casinf casinh casinhf casinhl casinl catan catanf catanh catanhf catanhl catanl catclose catgets catopen cbc_crypt cbrt cbrtf cbrtl ccos ccosf ccosh ccoshf ccoshl ccosl ceil ceilf ceill cexp cexpf cexpl cfgetispeed cfgetospeed cfmakeraw cfree cfsetispeed cfsetospeed cfsetspeed chdir chmod chown cimag cimagf cimagl clearenv clearerr clearerr_unlocked clock clog clog10 clog10f clog10l clogf clogl close closedir closelog confstr conj conjf conjl connect copysign copysignf copysignl cos cosf cosh coshf coshl cosl cpow cpowf cpowl cproj cprojf cprojl creal crealf creall creat creat64 crypt crypt_r csin csinf csinh csinhf csinhl csinl csqrt csqrtf csqrtl ctan ctanf ctanh ctanhf ctanhl ctanl ctermid ctime ctime_r cuserid
    syn keyword cLibFunction contained   dcgettext dcngettext des_setparity dgettext difftime dirfd dirname div dngettext drand48 drand48_r drem dremf dreml dup dup2
    syn keyword cLibFunction contained   ecb_crypt ecvt ecvt_r encrypt encrypt_r endfsent endgrent endhostent endmntent endnetent endnetgrent endprotoent endpwent endservent endutent endutxent envz_add envz_entry envz_get envz_merge envz_strip erand48 erand48_r erf erfc erfcf erfcl erff erfl err error error_at_line errx execl execle execlp execv execve execvp exit exp exp10 exp10f exp10l exp2 exp2f exp2l expf expl expm1 expm1f expm1l
    syn keyword cLibFunction contained   fabs fabsf fabsl fchdir fchmod fchown fclean fclose fcloseall fcntl fcvt fcvt_r fdatasync fdim fdimf fdiml fdopen feclearexcept fedisableexcept feenableexcept fegetenv fegetexcept fegetexceptflag fegetround feholdexcept feof feof_unlocked feraiseexcept ferror ferror_unlocked fesetenv fesetexceptflag fesetround fetestexcept feupdateenv fflush fflush_unlocked fgetc fgetc_unlocked fgetgrent fgetgrent_r fgetpos fgetpos64 fgetpwent fgetpwent_r fgets fgets_unlocked fgetwc fgetwc_unlocked fgetws fgetws_unlocked fileno fileno_unlocked finite finitef finitel flockfile floor floorf floorl fma fmaf fmal fmax fmaxf fmaxl fmemopen fmin fminf fminl fmod fmodf fmodl fmtmsg fnmatch fopen fopen64 fopencookie fork forkpty fpathconf fpclassify fprintf fputc fputc_unlocked fputs fputs_unlocked fputwc fputwc_unlocked fputws fputws_unlocked fread fread_unlocked free freopen freopen64 frexp frexpf frexpl fscanf fseek fseeko fseeko64 fsetpos fsetpos64 fstat fstat64 fsync ftell ftello ftello64 ftruncate ftruncate64 ftrylockfile ftw ftw64 funlockfile futimes fwide fwprintf fwrite fwrite_unlocked fwscanf
    syn keyword cLibFunction contained   gamma gammaf gammal gcvt get_avphys_pages get_current_dir_name get_nprocs get_nprocs_conf get_phys_pages getc getc_unlocked getchar getchar_unlocked getcontext getcwd getdate getdate_r getdelim getdomainnname getegid getenv geteuid getfsent getfsfile getfsspec getgid getgrent getgrent_r getgrgid getgrgid_r getgrnam getgrnam_r getgrouplist getgroups gethostbyaddr gethostbyaddr_r gethostbyname gethostbyname2 gethostbyname2_r gethostbyname_r gethostent gethostid gethostname getitimer getline getloadavg getlogin getmntent getmntent_r getnetbyaddr getnetbyname getnetent getnetgrent getnetgrent_r getopt getopt_long getopt_long_only getpagesize getpass getpeername getpgid getpgrp getpid getppid getpriority getprotobyname getprotobynumber getprotoent getpt getpwent getpwent_r getpwnam getpwnam_r getpwuid getpwuid_r getrlimit getrlimit64 getrusage gets getservbyname getservbyport getservent getsid getsockname getsockopt getsubopt gettext gettimeofday getuid getumask getutent getutent_r getutid getutid_r getutline getutline_r getutmp getutmpx getutxent getutxid getutxline getw getwc getwc_unlocked getwchar getwchar_unlocked getwd glob glob64 globfree globfree64 gmtime gmtime_r grantpt gsignal gtty
    syn keyword cLibFunction contained   hasmntopt hcreate hcreate_r hdestroy hdestroy_r hsearch hsearch_r htonl htons hypot hypotf hypotl
    syn keyword cLibFunction contained   iconv iconv_close iconv_open if_freenameindex if_indextoname if_nameindex if_nametoindex ilogb ilogbf ilogbl imaxabs imaxdiv index inet_addr inet_aton inet_lnaof inet_makeaddr inet_netof inet_network inet_ntoa inet_ntop inet_pton initgroups initstate initstate_r innetgr ioctl isalnum isalpha isascii isatty isblank iscntrl isdigit isfinite isgraph isgreater isgreaterequal isinf isinff isinfl isless islessequal islessgreater islower isnan isnanf isnanl isnormal isprint ispunct isspace isunordered isupper iswalnum iswalpha iswblank iswcntrl iswctype iswdigit iswgraph iswlower iswprint iswpunct iswspace iswupper iswxdigit isxdigit
    syn keyword cLibFunction contained   j0 j0f j0l j1 j1f j1l jn jnf jnl jrand48 jrand48_r
    syn keyword cLibFunction contained   kill killpg
    syn keyword cLibFunction contained   l64a labs lcong48 lcong48_r ldexp ldexpf ldexpl ldiv lfind lgamma lgamma_r lgammaf lgammaf_r lgammal lgammal_r link lio_listio lio_listio64 listen llabs lldiv llrint llrintf llrintl llround llroundf llroundl localeconv localtime localtime_r log log10 log10f log10l log1p log1pf log1pl log2 log2f log2l logb logbf logbl logf login login_tty logl logout logwtmp longjmp lrand48 lrand48_r lrint lrintf lrintl lround lroundf lroundl lsearch lseek lseek64 lstat lstat64 lutimes
    syn keyword cLibFunction contained   madvise main makecontext mallinfo malloc mallopt matherr mblen mbrlen mbrtowc mbsinit mbsnrtowcs mbsrtowcs mbstowcs mbtowc mcheck memalign memccpy memchr memcmp memcpy memfrob memmem memmove mempcpy memrchr memset mkdir mkdtemp mkfifo mknod mkstemp mktemp mktime mlock mlockall mmap mmap64 modf modff modfl mount mprobe mrand48 mrand48_r mremap msync mtrace munlock munlockall munmap muntrace
    syn keyword cLibFunction contained   nan nanf nanl nanosleep nearbyint nearbyintf nearbyintl nextafter nextafterf nextafterl nexttoward nexttowardf nexttowardl nftw nftw64 ngettext nice nl_langinfo notfound nrand48 nrand48_r ntohl ntohs ntp_adjtime ntp_gettime
    syn keyword cLibFunction contained   obstack_1grow obstack_1grow_fast obstack_alignment_mask obstack_alloc obstack_base obstack_blank obstack_blank_fast obstack_chunk_alloc obstack_chunk_free obstack_chunk_size obstack_copy obstack_copy0 obstack_finish obstack_free obstack_grow obstack_grow0 obstack_init obstack_int_grow obstack_int_grow_fast obstack_next_free obstack_object_size obstack_printf obstack_ptr_grow obstack_ptr_grow_fast obstack_room obstack_vprintf offsetof on_exit open open64 open_memstream open_obstack_stream opendir openlog openpty
    syn keyword cLibFunction contained   parse_printf_format pathconf pause pclose perror pipe popen posix_memalign pow pow10 pow10f pow10l powf powl pread pread64 printf printf_size printf_size_info psignal pthread_atfork pthread_attr_destroy pthread_attr_getattr pthread_attr_getdetachstate pthread_attr_getguardsize pthread_attr_getinheritsched pthread_attr_getschedparam pthread_attr_getschedpolicy pthread_attr_getscope pthread_attr_getstack pthread_attr_getstackaddr pthread_attr_getstacksize pthread_attr_init pthread_attr_setattr pthread_attr_setdetachstate pthread_attr_setguardsize pthread_attr_setinheritsched pthread_attr_setschedparam pthread_attr_setschedpolicy pthread_attr_setscope pthread_attr_setstack pthread_attr_setstackaddr pthread_attr_setstacksize pthread_cancel pthread_cleanup_pop pthread_cleanup_pop_restore_np pthread_cleanup_push pthread_cleanup_push_defer_np pthread_cond_broadcast pthread_cond_destroy pthread_cond_init pthread_cond_signal pthread_cond_timedwait pthread_cond_wait pthread_condattr_destroy pthread_condattr_init pthread_create pthread_detach pthread_equal pthread_exit pthread_getconcurrency pthread_getschedparam pthread_getspecific pthread_join pthread_key_create pthread_key_delete pthread_kill pthread_kill_other_threads_np pthread_mutex_destroy pthread_mutex_init pthread_mutex_lock pthread_mutex_timedlock pthread_mutex_trylock pthread_mutex_unlock pthread_mutexattr_destroy pthread_mutexattr_gettype pthread_mutexattr_init pthread_mutexattr_settype pthread_once pthread_self pthread_setcancelstate pthread_setcanceltype pthread_setconcurrency pthread_setschedparam pthread_setspecific pthread_sigmask pthread_testcancel ptsname ptsname_r putc putc_unlocked putchar putchar_unlocked putenv putpwent puts pututline pututxline putw putwc putwc_unlocked putwchar putwchar_unlocked pwrite pwrite64
    syn keyword cLibFunction contained   qecvt qecvt_r qfcvt qfcvt_r qgcvt qsort
    syn keyword cLibFunction contained   raise rand rand_r random random_r rawmemchr read readdir readdir64 readdir64_r readdir_r readlink readv realloc realpath recv recvfrom regcomp regerror regexec regfree register_printf_function remainder remainderf remainderl remove rename rewind rewinddir rindex rint rintf rintl rmdir round roundf roundl rpmatch
    syn keyword cLibFunction contained   sbrk scalb scalbf scalbl scalbln scalblnf scalblnl scalbn scalbnf scalbnl scandir scandir64 scanf sched_get_priority_max sched_get_priority_min sched_getaffinity sched_getparam sched_getscheduler sched_rr_get_interval sched_setaffinity sched_setparam sched_setscheduler sched_yield seed48 seed48_r seekdir select sem_destroy sem_getvalue sem_init sem_post sem_trywait sem_wait send sendto setbuf setbuffer setcontext setdomainname setegid setenv seteuid setfsent setgid setgrent setgroups sethostent sethostid sethostname setitimer setjmp setkey setkey_r setlinebuf setlocale setlogmask setmntent setnetent setnetgrent setpgid setpgrp setpriority setprotoent setpwent setregid setreuid setrlimit setrlimit64 setservent setsid setsockopt setstate setstate_r settimeofday setuid setutent setutxent setvbuf shutdown sigaction sigaddset sigaltstack sigblock sigdelset sigemptyset sigfillset siginterrupt sigismember siglongjmp sigmask signal signbit significand significandf significandl sigpause sigpending sigprocmask sigsetjmp sigsetmask sigstack sigsuspend sigvec sigwait sin sincos sincosf sincosl sinf sinh sinhf sinhl sinl sleep snprintf socket socketpair sprintf sqrt sqrtf sqrtl srand srand48 srand48_r srandom srandom_r sscanf ssignal stat stat64 stime stpcpy stpncpy strcasecmp strcasestr strcat strchr strchrnul strcmp strcoll strcpy strcspn strdup strdupa strerror strerror_r strfmon strfry strftime strlen strncasecmp strncat strncmp strncpy strndup strndupa strnlen strpbrk strptime strrchr strsep strsignal strspn strstr strtod strtof strtoimax strtok strtok_r strtol strtold strtoll strtoq strtoul strtoull strtoumax strtouq strverscmp strxfrm stty success swapcontext swprintf swscanf symlink sync syscall sysconf sysctl syslog system sysv_signal
    syn keyword cLibFunction contained   tan tanf tanh tanhf tanhl tanl tcdrain tcflow tcflush tcgetattr tcgetpgrp tcgetsid tcsendbreak tcsetattr tcsetpgrp tdelete tdestroy telldir tempnam textdomain tfind tgamma tgammaf tgammal time timegm timelocal times tmpfile tmpfile64 tmpnam tmpnam_r toascii tolower toupper towctrans towlower towupper trunc truncate truncate64 truncf truncl tryagain tsearch ttyname ttyname_r twalk tzset
    syn keyword cLibFunction contained   ulimit umask umount umount2 uname unavail ungetc ungetwc unlink unlockpt unsetenv updwtmp utime utimes utmpname utmpxname
    syn keyword cLibFunction contained   va_alist va_arg va_dcl va_end va_start valloc vasprintf verr verrx versionsort versionsort64 vfork vfprintf vfscanf vfwprintf vfwscanf vlimit vprintf vscanf vsnprintf vsprintf vsscanf vswprintf vswscanf vsyslog vtimes vwarn vwarnx vwprintf vwscanf
    syn keyword cLibFunction contained   wait wait3 wait4 waitpid warn warnx wcpcpy wcpncpy wcrtomb wcscasecmp wcscat wcschr wcschrnul wcscmp wcscoll wcscpy wcscspn wcsdup wcsftime wcslen wcsncasecmp wcsncat wcsncmp wcsncpy wcsnlen wcsnrtombs wcspbrk wcsrchr wcsrtombs wcsspn wcsstr wcstod wcstof wcstoimax wcstok wcstol wcstold wcstoll wcstombs wcstoq wcstoul wcstoull wcstoumax wcstouq wcswcs wcsxfrm wctob wctomb wctrans wctype wmemchr wmemcmp wmemcpy wmemmove wmempcpy wmemset wordexp wordfree wprintf write writev wscanf
    syn keyword cLibFunction contained   y0 y0f y0l y1 y1f y1l yn ynf ynl
    " }}}
endif

" glibc Variables [generated from "info libc 'Variable Index'"]
if c_hi_identifiers =~ '\v\C<(CONSTANTS|all)>'
    " {{{ Upper case constants not beginning with "_"
    syn keyword cLibVariable contained   ABDAY_1 ABDAY_2 ABDAY_3 ABDAY_4 ABDAY_5 ABDAY_6 ABDAY_7 ABMON_1 ABMON_10 ABMON_11 ABMON_12 ABMON_2 ABMON_3 ABMON_4 ABMON_5 ABMON_6 ABMON_7 ABMON_8 ABMON_9 ACCOUNTING AF_FILE AF_INET AF_LOCAL AF_UNIX AF_UNSPEC ALTWERASE ALT_DIGITS AM_STR ARGP_ERR_UNKNOWN ARGP_HELP_BUG_ADDR ARGP_HELP_DOC ARGP_HELP_EXIT_ERR ARGP_HELP_EXIT_OK ARGP_HELP_LONG ARGP_HELP_LONG_ONLY ARGP_HELP_POST_DOC ARGP_HELP_PRE_DOC ARGP_HELP_SEE ARGP_HELP_SHORT_USAGE ARGP_HELP_STD_ERR ARGP_HELP_STD_HELP ARGP_HELP_STD_USAGE ARGP_HELP_USAGE ARGP_IN_ORDER ARGP_KEY_ARG ARGP_KEY_ARGS ARGP_KEY_END ARGP_KEY_ERROR ARGP_KEY_FINI ARGP_KEY_HELP_ARGS_DOC ARGP_KEY_HELP_DUP_ARGS_NOTE ARGP_KEY_HELP_EXTRA ARGP_KEY_HELP_HEADER ARGP_KEY_HELP_POST_DOC ARGP_KEY_HELP_PRE_DOC ARGP_KEY_INIT ARGP_KEY_NO_ARGS ARGP_KEY_SUCCESS ARGP_LONG_ONLY ARGP_NO_ARGS ARGP_NO_ERRS ARGP_NO_EXIT ARGP_NO_HELP ARGP_PARSE_ARGV0 ARGP_SILENT ARG_MAX
    syn keyword cLibVariable contained   B0 B110 B115200 B1200 B134 B150 B1800 B19200 B200 B230400 B2400 B300 B38400 B460800 B4800 B50 B57600 B600 B75 B9600 BC_BASE_MAX BC_DIM_MAX BC_SCALE_MAX BC_STRING_MAX BOOT_TIME BRKINT BUFSIZ
    syn keyword cLibVariable contained   CCTS_OFLOW CHAR_MAX CHAR_MIN CHILD_MAX CIGNORE CLK_TCK CLOCAL CLOCKS_PER_SEC CODESET COLL_WEIGHTS_MAX COREFILE CPU_SETSIZE CREAD CRNCYSTR CRTS_IFLOW CS5 CS6 CS7 CS8 CSIZE CSTOPB CURRENCY_SYMBOL
    syn keyword cLibVariable contained   DAY_1 DAY_2 DAY_3 DAY_4 DAY_5 DAY_6 DAY_7 DBL_DIG DBL_EPSILON DBL_MANT_DIG DBL_MAX DBL_MAX_10_EXP DBL_MAX_EXP DBL_MIN DBL_MIN_10_EXP DBL_MIN_EXP DEAD_PROCESS DECIMAL_POINT DESERR_BADPARAM DESERR_HWERROR DESERR_NOHWDEVICE DESERR_NONE DES_DECRYPT DES_ENCRYPT DES_HW DES_SW DT_BLK DT_CHR DT_DIR DT_FIFO DT_REG DT_SOCK DT_UNKNOWN D_FMT D_T_FMT
    syn keyword cLibVariable contained   E2BIG EACCES EADDRINUSE EADDRNOTAVAIL EADV EAFNOSUPPORT EAGAIN EALREADY EAUTH EBACKGROUND EBADE EBADF EBADFD EBADMSG EBADR EBADRPC EBADRQC EBADSLT EBFONT EBUSY ECANCELED ECHILD ECHO ECHOCTL ECHOE ECHOK ECHOKE ECHONL ECHOPRT ECHRNG ECOMM ECONNABORTED ECONNREFUSED ECONNRESET ED EDEADLK EDEADLOCK EDESTADDRREQ EDIED EDOM EDOTDOT EDQUOT EEXIST EFAULT EFBIG EFTYPE EGRATUITOUS EGREGIOUS EHOSTDOWN EHOSTUNREACH EIDRM EIEIO EILSEQ EINPROGRESS EINTR EINVAL EIO EISCONN EISDIR EISNAM EL2HLT EL2NSYNC EL3HLT EL3RST ELIBACC ELIBBAD ELIBEXEC ELIBMAX ELIBSCN ELNRNG ELOOP EMEDIUMTYPE EMFILE EMLINK EMPTY EMSGSIZE EMULTIHOP ENAMETOOLONG ENAVAIL ENEEDAUTH ENETDOWN ENETRESET ENETUNREACH ENFILE ENOANO ENOBUFS ENOCSI ENODATA ENODEV ENOENT ENOEXEC ENOLCK ENOLINK ENOMEDIUM ENOMEM ENOMSG ENONET ENOPKG ENOPROTOOPT ENOSPC ENOSR ENOSTR ENOSYS ENOTBLK ENOTCONN ENOTDIR ENOTEMPTY ENOTNAM ENOTSOCK ENOTSUP ENOTTY ENOTUNIQ ENXIO EOF EOPNOTSUPP EOVERFLOW EPERM EPFNOSUPPORT EPIPE EPROCLIM EPROCUNAVAIL EPROGMISMATCH EPROGUNAVAIL EPROTO EPROTONOSUPPORT EPROTOTYPE EQUIV_CLASS_MAX ERA ERANGE ERA_D_FMT ERA_D_T_FMT ERA_T_FMT ERA_YEAR EREMCHG EREMOTE EREMOTEIO ERESTART EROFS ERPCMISMATCH ESHUTDOWN ESOCKTNOSUPPORT ESPIPE ESRCH ESRMNT ESTALE ESTRPIPE ETIME ETIMEDOUT ETOOMANYREFS ETXTBSY EUCLEAN EUNATCH EUSERS EWOULDBLOCK EXDEV EXFULL EXIT_FAILURE EXIT_SUCCESS EXPR_NEST_MAX EXTA EXTB
    syn keyword cLibVariable contained   FD_CLOEXEC FD_SETSIZE FE_DFL_ENV FE_DIVBYZERO FE_DOWNWARD FE_INEXACT FE_INVALID FE_NOMASK_ENV FE_OVERFLOW FE_TONEAREST FE_TOWARDZERO FE_UNDERFLOW FE_UPWARD FILENAME_MAX FLT_DIG FLT_EPSILON FLT_MANT_DIG FLT_MAX FLT_MAX_10_EXP FLT_MAX_EXP FLT_MIN FLT_MIN_10_EXP FLT_MIN_EXP FLT_RADIX FLT_ROUNDS FLUSHO FOPEN_MAX FPE_DECOVF_TRAP FPE_FLTDIV_TRAP FPE_FLTOVF_TRAP FPE_FLTUND_TRAP FPE_INTDIV_TRAP FPE_INTOVF_TRAP FPE_SUBRNG_TRAP FP_FAST_FMA FP_ILOGB0 FP_ILOGBNAN FP_INFINITE FP_NAN FP_NORMAL FP_SUBNORMAL FP_ZERO FRAC_DIGITS FSETLOCKING_BYCALLER FSETLOCKING_INTERNAL FSETLOCKING_QUERY FSTAB FSTAB_RO FSTAB_RQ FSTAB_RW FSTAB_SW FSTAB_XX FTW_ACTIONRETVAL FTW_CHDIR FTW_D FTW_DEPTH FTW_DNR FTW_DP FTW_F FTW_MOUNT FTW_NS FTW_PHYS FTW_SL FTW_SLN F_DUPFD F_GETFD F_GETFL F_GETLK F_GETOWN F_OK F_RDLCK F_SETFD F_SETFL F_SETLK F_SETLKW F_SETOWN F_UNLCK F_WRLCK
    syn keyword cLibVariable contained   GLOB_ABORTED GLOB_ALTDIRFUNC GLOB_APPEND GLOB_BRACE GLOB_DOOFFS GLOB_ERR GLOB_MAGCHAR GLOB_MARK GLOB_NOCHECK GLOB_NOESCAPE GLOB_NOMAGIC GLOB_NOMATCH GLOB_NOSORT GLOB_NOSPACE GLOB_ONLYDIR GLOB_PERIOD GLOB_TILDE GLOB_TILDE_CHECK GROUPING
    syn keyword cLibVariable contained   HOST_NOT_FOUND HUGE_VAL HUGE_VALF HUGE_VALL HUPCL
    syn keyword cLibVariable contained   I ICANON ICRNL IEXTEN IFNAMSIZ IGNBRK IGNCR IGNPAR IMAXBEL INADDR_ANY INADDR_BROADCAST INADDR_LOOPBACK INADDR_NONE INFINITY INIT_PROCESS INLCR INPCK INT_CURR_SYMBOL INT_FRAC_DIGITS INT_MAX INT_MIN INT_N_CS_PRECEDES INT_N_SEP_BY_SPACE INT_N_SIGN_POSN INT_P_CS_PRECEDES INT_P_SEP_BY_SPACE INT_P_SIGN_POSN IPPORT_RESERVED IPPORT_USERRESERVED ISIG ISTRIP ITIMER_PROF ITIMER_REAL ITIMER_VIRTUAL IXANY IXOFF IXON
    syn keyword cLibVariable contained   LANG LANGUAGE LC_ALL LC_COLLATE LC_CTYPE LC_MESSAGES LC_MONETARY LC_NUMERIC LC_TIME LDBL_DIG LDBL_EPSILON LDBL_MANT_DIG LDBL_MAX LDBL_MAX_10_EXP LDBL_MAX_EXP LDBL_MIN LDBL_MIN_10_EXP LDBL_MIN_EXP LINE_MAX LINK_MAX LIO_NOP LIO_READ LIO_WRITE LOGIN_PROCESS LOG_ALERT LOG_AUTH LOG_AUTHPRIV LOG_CRIT LOG_CRON LOG_DAEMON LOG_DEBUG LOG_EMERG LOG_ERR LOG_FTP LOG_INFO LOG_LOCAL0 LOG_LOCAL1 LOG_LOCAL2 LOG_LOCAL3 LOG_LOCAL4 LOG_LOCAL5 LOG_LOCAL6 LOG_LOCAL7 LOG_LPR LOG_MAIL LOG_NEWS LOG_NOTICE LOG_SYSLOG LOG_USER LOG_UUCP LOG_WARNING LONG_LONG_MAX LONG_LONG_MIN LONG_MAX LONG_MIN L_INCR L_SET L_XTND L_ctermid L_cuserid L_tmpnam
    syn keyword cLibVariable contained   MAP_ANON MAP_ANONYMOUS MAP_FIXED MAP_PRIVATE MAP_SHARED MAXNAMLEN MAXSYMLINKS MAX_CANON MAX_INPUT MB_CUR_MAX MB_LEN_MAX MDMBUF MINSIGSTKSZ MM_APPL MM_CONSOLE MM_ERROR MM_FIRM MM_HALT MM_HARD MM_INFO MM_NOSEV MM_NRECOV MM_NULLACT MM_NULLLBL MM_NULLMC MM_NULLSEV MM_NULLTAG MM_NULLTXT MM_OPSYS MM_PRINT MM_RECOVER MM_SOFT MM_UTIL MM_WARNING MNTOPT_DEFAULTS MNTOPT_NOAUTO MNTOPT_NOSUID MNTOPT_RO MNTOPT_RW MNTOPT_SUID MNTTAB MNTTYPE_IGNORE MNTTYPE_NFS MNTTYPE_SWAP MON_1 MON_10 MON_11 MON_12 MON_2 MON_3 MON_4 MON_5 MON_6 MON_7 MON_8 MON_9 MON_DECIMAL_POINT MON_GROUPING MON_THOUSANDS_SEP MOUNTED MSG_DONTROUTE MSG_OOB MSG_PEEK MS_ASYNC MS_SYNC M_1_PI M_2_PI M_2_SQRTPI M_E M_LN10 M_LN2 M_LOG10E M_LOG2E M_PI M_PI_2 M_PI_4 M_SQRT1_2 M_SQRT2
    syn keyword cLibVariable contained   NAME_MAX NAN NCCS NDEBUG NEGATIVE_SIGN NEW_TIME NGROUPS_MAX NL_ARGMAX NOEXPR NOFLSH NOKERNINFO NOSTR NO_ADDRESS NO_RECOVERY NSIG NSS_STATUS_NOTFOUND NSS_STATUS_SUCCESS NSS_STATUS_TRYAGAIN NSS_STATUS_UNAVAIL NULL N_CS_PRECEDES N_SEP_BY_SPACE N_SIGN_POSN
    syn keyword cLibVariable contained   OLD_TIME ONLCR ONOEOT OPEN_MAX OPOST OPTION_ALIAS OPTION_ARG_OPTIONAL OPTION_DOC OPTION_HIDDEN OPTION_NO_USAGE OXTABS O_ACCMODE O_APPEND O_ASYNC O_CREAT O_EXCL O_EXEC O_EXLOCK O_FSYNC O_IGNORE_CTTY O_NDELAY O_NOATIME O_NOCTTY O_NOLINK O_NONBLOCK O_NOTRANS O_RDONLY O_RDWR O_READ O_SHLOCK O_SYNC O_TRUNC O_WRITE O_WRONLY
    syn keyword cLibVariable contained   PARENB PARMRK PARODD PATH_MAX PA_CHAR PA_DOUBLE PA_FLAG_LONG PA_FLAG_LONG_DOUBLE PA_FLAG_LONG_LONG PA_FLAG_MASK PA_FLAG_PTR PA_FLAG_SHORT PA_FLOAT PA_INT PA_LAST PA_POINTER PA_STRING PENDIN PF_CCITT PF_FILE PF_IMPLINK PF_INET PF_INET6 PF_ISO PF_LOCAL PF_NS PF_ROUTE PF_UNIX PI PIPE_BUF PM_STR POSITIVE_SIGN PRIO_MAX PRIO_MIN PRIO_PGRP PRIO_PROCESS PRIO_USER PROT_EXEC PROT_READ PROT_WRITE PWD P_CS_PRECEDES P_SEP_BY_SPACE P_SIGN_POSN P_tmpdir
    syn keyword cLibVariable contained   RADIXCHAR RAND_MAX RE_DUP_MAX RLIMIT_AS RLIMIT_CORE RLIMIT_CPU RLIMIT_DATA RLIMIT_FSIZE RLIMIT_NOFILE RLIMIT_OFILE RLIMIT_RSS RLIMIT_STACK RLIM_INFINITY RLIM_NLIMITS RUN_LVL R_OK
    syn keyword cLibVariable contained   SA_NOCLDSTOP SA_ONSTACK SA_RESTART SCHAR_MAX SCHAR_MIN SC_SSIZE_MAX SEEK_CUR SEEK_END SEEK_SET SEM_VALUE_MAX SHRT_MAX SHRT_MIN SIGABRT SIGALRM SIGBUS SIGCHLD SIGCLD SIGCONT SIGEMT SIGFPE SIGHUP SIGILL SIGINFO SIGINT SIGIO SIGIOT SIGKILL SIGLOST SIGPIPE SIGPOLL SIGPROF SIGQUIT SIGSEGV SIGSTKSZ SIGSTOP SIGSYS SIGTERM SIGTRAP SIGTSTP SIGTTIN SIGTTOU SIGURG SIGUSR1 SIGUSR2 SIGVTALRM SIGWINCH SIGXCPU SIGXFSZ SIG_BLOCK SIG_DFL SIG_ERR SIG_IGN SIG_SETMASK SIG_UNBLOCK SOCK_DGRAM SOCK_RAW SOCK_STREAM SOL_SOCKET SSIZE_MAX SS_DISABLE SS_ONSTACK STDERR_FILENO STDIN_FILENO STDOUT_FILENO STREAM_MAX SV_INTERRUPT SV_ONSTACK SV_RESETHAND S_IEXEC S_IFBLK S_IFCHR S_IFDIR S_IFIFO S_IFLNK S_IFMT S_IFREG S_IFSOCK S_IREAD S_IRGRP S_IROTH S_IRUSR S_IRWXG S_IRWXO S_IRWXU S_ISGID S_ISUID S_ISVTX S_IWGRP S_IWOTH S_IWRITE S_IWUSR S_IXGRP S_IXOTH S_IXUSR
    syn keyword cLibVariable contained   TCIFLUSH TCIOFF TCIOFLUSH TCION TCOFLUSH TCOOFF TCOON TCSADRAIN TCSAFLUSH TCSANOW TCSASOFT THOUSANDS_SEP THOUSEP TMP_MAX TOSTOP TRY_AGAIN TZNAME_MAX T_FMT T_FMT_AMPM
    syn keyword cLibVariable contained   UCHAR_MAX UINT_MAX ULONG_LONG_MAX ULONG_MAX USER_PROCESS USHRT_MAX
    syn keyword cLibVariable contained   VDISCARD VDSUSP VEOF VEOL VEOL2 VERASE VINTR VKILL VLNEXT VMIN VQUIT VREPRINT VSTART VSTATUS VSTOP VSUSP VTIME VWERASE
    syn keyword cLibVariable contained   WCHAR_MAX WCHAR_MIN WEOF W_OK
    syn keyword cLibVariable contained   X_OK
    syn keyword cLibVariable contained   YESEXPR YESSTR
    " }}}
endif

if c_hi_identifiers =~ '\v\C<(_CONSTANTS|all)>'
    " {{{ Upper case constants beginning with "_"
    syn keyword cLibVariable contained   _BSD_SOURCE
    syn keyword cLibVariable contained   _Complex_I
    syn keyword cLibVariable contained   _FILE_OFFSET_BITS
    syn keyword cLibVariable contained   _GNU_SOURCE
    syn keyword cLibVariable contained   _IOFBF _IOLBF _IONBF _ISOC99_SOURCE
    syn keyword cLibVariable contained   _LARGEFILE64_SOURCE _LARGEFILE_SOURCE
    syn keyword cLibVariable contained   _PATH_FSTAB _PATH_MNTTAB _PATH_MOUNTED _PATH_UTMP _PATH_WTMP _POSIX2_C_DEV _POSIX2_C_VERSION _POSIX2_FORT_DEV _POSIX2_FORT_RUN _POSIX2_LOCALEDEF _POSIX2_SW_DEV _POSIX_CHOWN_RESTRICTED _POSIX_C_SOURCE _POSIX_JOB_CONTROL _POSIX_NO_TRUNC _POSIX_SAVED_IDS _POSIX_SOURCE _POSIX_VDISABLE _POSIX_VERSION
    syn keyword cLibVariable contained   _REENTRANT
    syn keyword cLibVariable contained   _SC_2_C_DEV _SC_2_FORT_DEV _SC_2_FORT_RUN _SC_2_LOCALEDEF _SC_2_SW_DEV _SC_2_VERSION _SC_AIO_LISTIO_MAX _SC_AIO_MAX _SC_AIO_PRIO_DELTA_MAX _SC_ARG_MAX _SC_ASYNCHRONOUS_IO _SC_ATEXIT_MAX _SC_AVPHYS_PAGES _SC_BC_BASE_MAX _SC_BC_DIM_MAX _SC_BC_SCALE_MAX _SC_BC_STRING_MAX _SC_CHARCLASS_NAME_MAX _SC_CHAR_BIT _SC_CHAR_MAX _SC_CHAR_MIN _SC_CHILD_MAX _SC_CLK_TCK _SC_COLL_WEIGHTS_MAX _SC_DELAYTIMER_MAX _SC_EQUIV_CLASS_MAX _SC_EXPR_NEST_MAX _SC_FSYNC _SC_GETGR_R_SIZE_MAX _SC_GETPW_R_SIZE_MAX _SC_INT_MAX _SC_INT_MIN _SC_JOB_CONTROL _SC_LINE_MAX _SC_LOGIN_NAME_MAX _SC_LONG_BIT _SC_MAPPED_FILES _SC_MB_LEN_MAX _SC_MEMLOCK _SC_MEMLOCK_RANGE _SC_MEMORY_PROTECTION _SC_MESSAGE_PASSING _SC_MQ_OPEN_MAX _SC_MQ_PRIO_MAX _SC_NGROUPS_MAX _SC_NL_ARGMAX _SC_NL_LANGMAX _SC_NL_MSGMAX _SC_NL_NMAX _SC_NL_SETMAX _SC_NL_TEXTMAX _SC_NPROCESSORS_CONF _SC_NPROCESSORS_ONLN _SC_NZERO _SC_OPEN_MAX _SC_PAGESIZE _SC_PHYS_PAGES _SC_PII _SC_PII_INTERNET _SC_PII_INTERNET_DGRAM _SC_PII_INTERNET_STREAM _SC_PII_OSI _SC_PII_OSI_CLTS _SC_PII_OSI_COTS _SC_PII_OSI_M _SC_PII_SOCKET _SC_PII_XTI _SC_PRIORITIZED_IO _SC_PRIORITY_SCHEDULING _SC_REALTIME_SIGNALS _SC_RTSIG_MAX _SC_SAVED_IDS _SC_SCHAR_MAX _SC_SCHAR_MIN _SC_SELECT _SC_SEMAPHORES _SC_SEM_NSEMS_MAX _SC_SEM_VALUE_MAX _SC_SHARED_MEMORY_OBJECTS _SC_SHRT_MAX _SC_SHRT_MIN _SC_SIGQUEUE_MAX _SC_STREAM_MAX _SC_SYNCHRONIZED_IO _SC_THREADS _SC_THREAD_ATTR_STACKADDR _SC_THREAD_ATTR_STACKSIZE _SC_THREAD_DESTRUCTOR_ITERATIONS _SC_THREAD_KEYS_MAX _SC_THREAD_PRIORITY_SCHEDULING _SC_THREAD_PRIO_INHERIT _SC_THREAD_PRIO_PROTECT _SC_THREAD_PROCESS_SHARED _SC_THREAD_SAFE_FUNCTIONS _SC_THREAD_STACK_MIN _SC_THREAD_THREADS_MAX _SC_TIMERS _SC_TIMER_MAX _SC_TTY_NAME_MAX _SC_TZNAME_MAX _SC_T_IOV_MAX _SC_UCHAR_MAX _SC_UINT_MAX _SC_UIO_MAXIOV _SC_ULONG_MAX _SC_USHRT_MAX _SC_VERSION _SC_WORD_BIT _SC_XOPEN_CRYPT _SC_XOPEN_ENH_I18N _SC_XOPEN_LEGACY _SC_XOPEN_REALTIME _SC_XOPEN_REALTIME_THREADS _SC_XOPEN_SHM _SC_XOPEN_UNIX _SC_XOPEN_VERSION _SC_XOPEN_XCU_VERSION _SC_XOPEN_XPG2 _SC_XOPEN_XPG3 _SC_XOPEN_XPG4 _SVID_SOURCE
    syn keyword cLibVariable contained   _THREAD_SAFE
    syn keyword cLibVariable contained   _XOPEN_SOURCE _XOPEN_SOURCE_EXTENDED
    " }}}
endif

if c_hi_identifiers =~ '\v\C<(constants|all)>'
    " {{{ Lower case constants
    syn keyword cLibVariable contained   __free_hook
    syn keyword cLibVariable contained   __gconv_end_fct __gconv_fct __gconv_init_fct
    syn keyword cLibVariable contained   __malloc_hook __malloc_initialize_hook __memalign_hook
    syn keyword cLibVariable contained   __realloc_hook
    syn keyword cLibVariable contained   aliases argp_err_exit_status argp_program_bug_address argp_program_version argp_program_version_hook
    syn keyword cLibVariable contained   daylight
    syn keyword cLibVariable contained   environ errno error_message_count error_one_per_line error_print_progname ethers
    syn keyword cLibVariable contained   getdate_err group
    syn keyword cLibVariable contained   h_errno hosts
    syn keyword cLibVariable contained   in6addr_any in6addr_loopback
    syn keyword cLibVariable contained   netgroup networks
    syn keyword cLibVariable contained   obstack_alloc_failed_handler optarg opterr optind optopt
    syn keyword cLibVariable contained   passwd program_invocation_name program_invocation_short_name protocols
    syn keyword cLibVariable contained   rpc
    syn keyword cLibVariable contained   services shadow signgam stderr stdin stdout sys_siglist
    syn keyword cLibVariable contained   timezone tzname
    " }}}
endif


let b:current_syntax = "c"
