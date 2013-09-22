" Perl Override Settings
setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4

" Comma always followed by a space
inoremap  ,  ,<Space>

inoremap <buffer> <silent> > ><Esc>:call <SID>perlhashalign()<CR>A
function! s:perlhashalign()
    let p = '^\s*\w+\s*[=+]>.*$'
    let lineContainsHashrocket = getline('.') =~# '^\s*\w+\s*[=+]>'
    let hashrocketOnPrevLine = getline(line('.') - 1) =~# p
    let hashrocketOnNextLine = getline(line('.') + 1) =~# p
    if exists(':Tabularize') " && lineContainsHashrocket && (hashrocketOnPrevLine || hashrocketOnNextLine)
        Tabularize /=>/l1
        normal! 0
    endif
endfunction

" Does Not Work, trying to align assignment operator 
"
"inoremap <buffer> <silent> = =<Esc>:call <SID>perlassignalign()<CR>A
"function! s:perlassignalign()
"    let p = '\s+=\s+'
"    let lineContainsAssign = getline('.') =~# '\s+=\s+'
"    let assignOnPrevLine = getline(line('.') - 1) =~# p
"    let assignOnNextLine = getline(line('.') + 1) =~# p
"    if exists(':Tabularize') " && lineContainsAssign && (assignOnPrevLine || assignOnNextLine)
"        Tabularize /=/l1
"        normal! 0
"    endif
"endfunction

