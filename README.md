# vim-overview

This is a vim plugin for [overview](https://github.com/mkirc/overview.git),
a pandoc-based for taking (eg. lecture) notes with markdown and LaTeX.
It produces a html file with mathML support via [temml](https://temml.org).

## Installation

You can install this plugin for example via
[vim-plug](https://github.com/junegunn/vim-plug)
by appending `Plug mkirc/vim-overview, { 'do': './install.sh' }` to the
vim-plug section in your vimrc and running `:PlugInstall`
in vim. This runs a short [install script](https://github.com/mkirc/vim-overview/blob/main/install.sh)
to install python dependencies. You can also skip the {'do'} part and run the
script yourself via `bash install.sh`.

Alternatively you can clone this repository
in your `~/.vim/autoload/` directory. Make sure to
run [install.sh](https://github.com/mkirc/vim-overview/blob/main/install.sh).

This project depends on `python version >= 3.9`, `bash` and
`pandoc`.

## Usage

`vim-overview` registers the following commands
when installed:

`\or` : Recompiles the current document and produces
an html file with the same filename in the same directory.

`\oo` : Start/Stop continuous recompilation of the current
file on save.

`\ov` : Opens the compiled html file with the prefered
Webbrowser (uses `xdg-open`).

## Filetype

`vim-overview` treats every input file as markdown, regardless of
encoding or extension.

`vim-overview` registers a custom filetype `.mtex` as `tex.markdown`,
so that you can use your tex- and markdown-specific settings (eg.
[Ultisnips](https://github.com/SirVer/ultisnips) snippets).
