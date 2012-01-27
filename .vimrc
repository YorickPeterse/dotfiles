" General settings
set nocompatible
set textwidth=80
set number
set backspace=indent,eol,start
set omnifunc=syntaxcomplete#Complete
set nowrap
set backupskip=/tmp/*,/private/tmp/*
set clipboard=unnamed
set pastetoggle=<F2>
set mouse=a

" colorcolumn doesn't work on slightly older versions of Vim.
if version >= 703
  set colorcolumn=80
endif

" Printer options
set printoptions=number:n
set printoptions=header:0

" Allow per directory .vimrc files
set exrc
set secure

" Enable Pathogen
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

" Settings for Syntastic.
set statusline=\ \"%t\"\ %y\ %m%#warningmsg#%{SyntasticStatuslineFlag()}%*
let g:syntastic_auto_loc_list = 0
let g:syntastic_stl_format    = '[%E{Errors: %e, line %fe}%B{ | }'
let g:syntastic_stl_format   .= '%W{Warnings: %w, line %fw}]'

" Font settings. I use Monaco on Linux based systems and Consolas on
" others (Inconsolata doesn't render too well on Linux based OS').
if has('gui_gtk2')
  set guifont=Monaco\ 10
else
  set guifont=Consolas:h14
endif

filetype plugin indent on
syntax on
color autumn

" Indentation settings
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Customize various key settings and commands.
let mapleader             = ','
let maplocalleader        = '\'
let g:user_zen_leader_key = '<c-e>'
let g:user_zen_settings   = {'indentation' : '    '}
let g:snips_author        = 'Yorick Peterse'
let NERDTreeShowBookmarks = 0

function! Trim()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//eg
  call cursor(l, c)
:endfunction

" Function that switches Vim into "Email" mode allowing me to write nicely
" aligned Emails in Vim.
function! Email()
  set ft=mail
  set colorcolumn=72
  set textwidth=72
:endfunction

" Automatically strip trailing whitespace.
autocmd! BufWritePre * :call Trim()

" Set a few filetypes for some uncommon extendsions
autocmd! BufRead,BufNewFile *.xhtml  set filetype=html
autocmd! BufRead,BufNewFile *.md     set filetype=markdown
autocmd! BufRead,BufNewFile Gemfile  set filetype=ruby
autocmd! BufRead,BufNewFile Isolate  set filetype=ruby
autocmd! BufRead,BufNewFile *.rake   set filetype=ruby
autocmd! BufRead,BufNewFile *.ru     set filetype=ruby
autocmd! BufRead,BufNewFile *        match Visual /\s\+$/

autocmd! FileType ruby setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd! FileType yaml setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd! FileType vim  setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

" Use actual tabs instead of spaces for Perl and PHP.
autocmd! FileType perl setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab
autocmd! FileType php  setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab

" Custom key bindings
map <F3> :call Email()<CR><Esc>
map <F4> :Errors<CR><Esc>
