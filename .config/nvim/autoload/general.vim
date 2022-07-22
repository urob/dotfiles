" Toggle quickfix list and location list
function general#GetBufferList() abort
    redir =>buflist
    silent! ls!
    redir END
    return buflist
endfunction

function general#ToggleList(bufname, pfx)
    let buflist = general#GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
            exec(a:pfx.'close')
            return
        endif
    endfor
    if a:pfx == 'l' && len(getloclist(0)) == 0
        echohl ErrorMsg
        echo "Location List is Empty."
        return
    endif
    let winnr = winnr()
    exec(a:pfx.'open')
    if winnr() != winnr
        wincmd p
    endif
endfunction


" Toggle NERDTree
function! general#NERDTreeToggleInCurDir()
    " If NERDTree is open in the current buffer
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exec ":NERDTreeClose"
    else
        if (expand("%:t") != '')
            exec ":NERDTreeFind"
        else
            exec ":NERDTreeToggle"
        endif
    endif
endfunction


" Convert file endings from dos to unix
function! general#dos2unix()
    exec 'e ++ff=dos'
    exec 'w ++ff=unix'
endfunction


" Word count
function general#WordCount() abort
    if (&ft!="markdown" && &ft!="latex")
        return ""
    endif

    let currentmode = mode()
    if !exists("g:lastmode_wc")
        let g:lastmode_wc = currentmode
    endif
    " if we modify file, open a new buffer, be in visual ever, or switch modes
    " since last run, we recompute.
    if (&modified || !exists("b:wordcount") || currentmode =~? '\c.*v' || currentmode != g:lastmode_wc) && currentmode != 's'
        let g:lastmode_wc = currentmode
        let l:old_position = getpos('.')
        let l:old_status = v:statusmsg
        execute "silent normal g\<c-g>"
        if v:statusmsg == "--No lines in buffer--"
            let b:wordcount = 0
        else
            let s:split_wc = split(v:statusmsg)
            if index(s:split_wc, "Selected") < 0
                let b:wordcount = str2nr(s:split_wc[11])
            else
                let b:wordcount = str2nr(s:split_wc[5])
            endif
            let v:statusmsg = l:old_status
        endif
        call setpos('.', l:old_position)
        return "" . b:wordcount . "w "
    else
        return "" . b:wordcount . "w "
    endif
endfunction
