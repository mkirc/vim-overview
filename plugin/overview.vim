
let s:ov_path = [resolve(expand('<sfile>:p:h:h')) . "/overview/overview.bash"]
let s:continous = 0


function! overview#Recompile()

    echo 'recompiling...'

    let l:infile = expand('%')

    if !filereadable(l:infile)
        echo 'ov recompile failed: no file given.'
        return 0
    endif

    let l:outfile_arg = ['-o']
    let l:outfile = [shellescape(expand('%:p:r').'.html')]
    let l:infile = [shellescape(l:infile)]

    let l:cmd = ['bash'] + s:ov_path + l:infile + l:outfile_arg + l:outfile

    let l:ret = system(join(l:cmd, " "))

    redraw

    if v:shell_error == 0
        echo 'ov recompile: done'
        return 1
    elseif v:shell_error >= 1
        echo 'ov recompile: an error ocurred ['.v:shell_error.']'
        return 0
    endif
endfunction

function! overview#ViewHTML()
    let l:filename = expand('%:p:r').'.html'

    if filereadable(l:filename)
        call overview#OpenInBrowser(l:filename)
    else
        let l:ret = overview#Recompile()
        if l:ret == 1
            call overview#OpenInBrowser(l:filename)
        endif
    endif
endfunction

function! overview#OpenInBrowser(filename)
    if filereadable(a:filename)
        silent execute '! xdg-open '. shellescape(a:filename)
        redraw!
    endif
endfunction

function! overview#ToggleCompileOnSave()

    if s:continous == 0
        echo 'ov continous recompilation started.'
        augroup vimov
            autocmd!
            autocmd BufWritePost *.mtex call overview#Recompile()
        augroup END
        let s:continous = 1
        return
    elseif s:continous == 1
        echo 'ov continous recompilation stopped.'
        augroup vimov
            autocmd!
        augroup END
        let s:continous = 0
        return
    endif
endfunction


""""""" Keyboard Mapping """"""

nnoremap <Leader>or :call overview#Recompile()<CR>
nnoremap <Leader>oo :call overview#ToggleCompileOnSave()<CR>
nnoremap <Leader>ov :call overview#ViewHTML()<CR>
