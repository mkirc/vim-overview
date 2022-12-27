" define mtex markdown + latex filetype

augroup filetypedetect
    au! BufRead,BufNewFile *.mtex set filetype=tex.markdown
augroup END
