
let s:ov_path = [resolve(expand('<sfile>:p:h:h')) . "/overview/overview.bash"]


function! overview#RecompileCurrentFile()

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


""""""" Keyboard Mapping """"""

nnoremap <Leader>or :call overview#RecompileCurrentFile()<CR>
