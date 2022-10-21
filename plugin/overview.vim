

function! overview#RecompileCurrentFile()

    let l:ov_path = ['~/Hub/overview/makeOverview.bash']
    let l:infile = [shellescape(expand('%'))]

    let l:outfile_arg = ['-o']
    let l:outfile = [shellescape(expand('%:p:r').'.html')]
    let l:cmd = ['bash'] + l:ov_path + l:infile + l:outfile_arg + l:outfile

    let l:ret = system(join(l:cmd, " "))

    if v:shell_error == 0
        return 1
    elseif v:shell_error == 1
        return 0
    else
        return v:shell_error
    endif
endfunction


function! overview#Main()

    let l:recompile_retval = overview#RecompileCurrentFile()

    if l:recompile_retval == 1
        echo 'ov recompile: done'
    else
        echo 'ov recompile: an error ocurred ['.l:recompile_retval.']'
    endif

    return l:recompile_retval

endfunction


""""""" Keyboard Mapping """"""

nnoremap <Leader>ov :call overview#Main()<CR>
