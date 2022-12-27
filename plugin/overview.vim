
let s:ov_path = [resolve(expand('<sfile>:p:h:h')) . "/overview/overview.bash"]
let s:continous = 0


function! overview#Recompile()

    echo 'recompiling...'

    let l:infile = [shellescape(expand('%'))]

    let l:outfile_arg = ['-o']
    let l:outfile = [shellescape(expand('%:p:r').'.html')]

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
