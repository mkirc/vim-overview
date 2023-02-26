
let s:continous = 0

let s:autoreload_path = [resolve(expand('<sfile>:p:h')) . "/start_autoreload_server.bash"]
let s:ov_path = [resolve(expand('<sfile>:p:h:h')) . '/overview/overview.bash']
let s:ws_js_path = resolve(expand('<sfile>:p:h:h')) . "/ws-autoreload/autoreload.js"
let s:python = [resolve(expand('<sfile>:p:h:h')) . '/ws-autoreload/venv/bin/python']
let s:get_port_script = [resolve(expand('<sfile>:p:h')) . '/get_unused_port.py']

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

    if s:continous == 1
        let l:script_tag = ['<script type="text/javascript">let wsPort=' . s:autoreload_port . '</script>']
        let l:script_tag += ['<script type="text/javascript" src="' . s:ws_js_path . '"></script>']
        let l:js_arg = ['--additional-js']
        let l:cmd += l:js_arg + [shellescape(join(l:script_tag,""))]
        " echo 'js injected'
    endif

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

function! overview#GetUnusedPort()
    let s:autoreload_port = system(join(s:python + s:get_port_script, " "))

    if v:shell_error == 0
        return 1
    elseif v:shell_error >= 1
        return 0
    endif
endfunction

function! overview#StartAutoreloadServer()

    let l:dirname = [shellescape(expand('%:p:h'))]
    let l:cmd = s:autoreload_path + l:dirname + ['--port'] + [s:autoreload_port]

    let s:autoreload_pid = system(join(l:cmd, " "))

    if v:shell_error == 0
        return 1
    elseif v:shell_error >= 1
        return 0
    endif
endfunction

function! overview#StopAutoreloadServer()
    call system('kill -9 '. s:autoreload_pid)
    if v:shell_error == 0
        return 1
    elseif v:shell_error >= 1
        return 0
    endif
endfunction

function! overview#ToggleCompileOnSave()

    if s:continous == 0
        let s:continous = 1
        call overview#GetUnusedPort()
        if s:autoreload_port == 0
            echo 'ov [WARNING]: all ports in use, aborting!'
            return
        endif
        call overview#Recompile()
        call overview#StartAutoreloadServer()
        augroup vimov
            autocmd!
            autocmd BufWritePost *.mtex call overview#Recompile()
        augroup END
        redraw
        echo 'ov continous recompilation started.'
        return
    elseif s:continous == 1
        let s:continous = 0
        call overview#Recompile()
        call overview#StopAutoreloadServer()
        augroup vimov
            autocmd!
        augroup END
        redraw
        echo 'ov continous recompilation stopped.'
        return
    endif
endfunction


""""""" Keyboard Mapping """"""

nnoremap <Leader>or :call overview#Recompile()<CR>
nnoremap <Leader>oo :call overview#ToggleCompileOnSave()<CR>
nnoremap <Leader>ov :call overview#ViewHTML()<CR>
nnoremap <Leader>op :call overview#GetUnusedPort()<CR>
