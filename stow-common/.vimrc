" Minimal vim configuration for SSH sessions
set nocompatible              " Use Vim defaults
syntax on                     " Enable syntax highlighting

" Essential UI
set number                    " Show line numbers
set ruler                     " Show cursor position
set showcmd                   " Show command in status line

" Search
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive if uppercase present

" Indentation (per style.ysap.sh)
set autoindent                " Copy indent from current line
set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set noexpandtab               " Use tabs

" File handling
set encoding=utf-8            " UTF-8 encoding
set autoread                  " Auto-reload changed files

" Disable backups/swaps
set nobackup
set nowritebackup
set noswapfile
