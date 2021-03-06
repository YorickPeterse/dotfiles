" ============================================================================
" VIM CONFIGURATION FILE
"
" This file contains all the Vim configuration settings that I use across
" different computers. These settings include setting themes, remapping leader
" keys, callbacks and many other settings. Font related settings are set in
" ~/.hvimrc instead since different setups tend to render fonts completely
" different (at least in my experience).
"
" The code in this configuration file is released in the public domain. You're
" free to use it as you see fit.
"
" Author:  Yorick Peterse
" Website: http://yorickpeterse.com/
" License: Public Domain

" ============================================================================
" GENERAL SETTINGS
"
" A collection of general Vim settings such as enabling the use of the mouse,
" what key combination to use for toggling the paste mode and various other
" settings.
"
set backspace=indent,eol,start
set omnifunc=syntaxcomplete#Complete
set backupskip=/tmp/*
set clipboard=unnamed
set pastetoggle=<F2>
set guitablabel=%f
set statusline=%f\ %w%m%r
set splitright

" Disable the mouse to force myself to not use it.
set mouse=

set nohlsearch
set noincsearch
set title

" Printer settings
set printoptions=number:n
set printoptions=header:0

let mapleader      = ','
let maplocalleader = '\'

" These settings are disabled to get some extra performance out of Vim when
" dealing with large files.
set nocursorcolumn
set nocursorline

if executable('rg')
    set grepprg=rg\ --vimgrep
endif

" ============================================================================
" PLUGIN SETTINGS
"

let g:plug_url_format = 'git@github.com:%s.git'

call plug#begin('~/.vim/plugged')

Plug 'godlygeek/tabular'
Plug 'pangloss/vim-javascript'
Plug 'Raimondi/delimitMate'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'neomake/neomake'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-fugitive'
Plug 'dag/vim-fish'
Plug '~/.vim/plugged/inko.vim'
Plug 'YorickPeterse/happy_hacking.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

call plug#end()

" UltiSnips settings.
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" NERDTree settings.
let NERDTreeShowBookmarks = 0
let NERDTreeIgnore        = ['\.pyc$', '\.pyo$', '__pycache__', '\.o$', 'rustc-incremental']
let NERDTreeWinSize       = 25

" Neomake
let g:neomake_error_sign = {'text': 'X', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '!', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '>', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'i', 'texthl': 'NeomakeInfoSign'}

" rust.vim
let g:rustfmt_fail_silently = 1
let g:rustfmt_autosave = 1

" delimitMate
let delimitMate_expand_cr = 1

" gutentags
let g:gutentags_ctags_exclude = ['target', 'tmp', 'spec']

" FZF
let $FZF_DEFAULT_COMMAND = 'rg --files --follow'

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Notice'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Comment'],
  \ 'pointer': ['fg', 'Normal'],
  \ 'marker':  ['fg', 'Normal'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

function! s:fzf_statusline()
  setlocal statusline=FZF
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

" Tabline
function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .': '
    let s .= (bufname != '' ? fnamemodify(bufname, ':t') . ' ' : '[No Name] ')

    if bufmodified
      let s .= '[+] '
    endif
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()

" ============================================================================
" SYNTAX SETTINGS
"
" Settings related to configuring the syntax features of Vim such as the text
" width, what theme to use and so on.
"
set textwidth=80
set nowrap
set number
set synmaxcol=256
set diffopt=filler,vertical
filetype plugin indent on
syntax on
color happy_hacking

" Enable true colors in terminals, even in Tmux
set termguicolors

" colorcolumn doesn't work on slightly older versions of Vim.
if version >= 703
  set colorcolumn=80
endif

" Indentation settings
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" ============================================================================
" CUSTOM FUNCTIONS
"
" A collection of custom functions such as a function used for trimming
" trailing whitespace or converting a file's encoding to UTF-8.

" Removes trailing whitespace from the current buffer.
function! Trim()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//eg
  call cursor(l, c)
:endfunction

" ============================================================================
" HOOKS
"
" Collection of various hooks that have to be executed when a certain filetype
" is set or action is executed.

" Automatically strip trailing whitespace.
autocmd! BufWritePre * :call Trim()
autocmd! BufWritePost * Neomake

" Set a few filetypes for some uncommon extensions
autocmd! BufRead,BufNewFile *.md     set filetype=markdown
autocmd! BufRead,BufNewFile Gemfile  set filetype=ruby
autocmd! BufRead,BufNewFile *.rake   set filetype=ruby
autocmd! BufRead,BufNewFile *.ru     set filetype=ruby
autocmd! BufRead,BufNewFile *.rs     set filetype=rust
autocmd! BufRead,BufNewFile *.rll    set filetype=rll

" Taken from http://vim.wikia.com/wiki/Highlight_unwanted_spaces
autocmd BufWinEnter * match Visual /\s\+$/
autocmd InsertEnter * match Visual /\s\+\%#\@<!$/
autocmd InsertLeave * match Visual /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Use 2 spaces per indentation level for Ruby, YAML and Vim script.
autocmd! FileType ruby   setlocal sw=2 sts=2 ts=2 expandtab
autocmd! FileType eruby  setlocal sw=2 sts=2 ts=2 expandtab
autocmd! FileType yaml   setlocal sw=2 sts=2 ts=2 expandtab
autocmd! FileType coffee setlocal sw=2 sts=2 ts=2 expandtab
autocmd! FileType haml   setlocal sw=2 sts=2 ts=2 expandtab
autocmd! FileType rust   setlocal tw=80

" ============================================================================
" KEY BINDINGS
"
" A collection of custom key bindings.
"
map <F6> :NERDTreeToggle<CR><Esc>

" I press this combination so often by accident it's really annoying, I have no
" need for it so go away.
map K <nop>

" Using the scroll wheel makes my shoulder cry out in pain.
map <ScrollWheelUp> <nop>
map <S-ScrollWheelUp> <nop>
map <ScrollWheelDown> <nop>
map <S-ScrollWheelDown> <nop>
map <ScrollWheelLeft> <nop>
map <S-ScrollWheelLeft> <nop>
map <ScrollWheelRight> <nop>
map <S-ScrollWheelRight> <nop>

" FZF
map <leader>f :call fzf#vim#files('.', {'options': '--prompt ">> "'})<CR>
map <leader>t :call fzf#vim#buffer_tags('', {'options': '--prompt ">> " --no-reverse'})<CR>
map <leader>b :call fzf#vim#buffers('', {'options': '--prompt ">> " --no-reverse'})<CR>

" Neovim terminals
tnoremap <C-]> <C-\><C-n>
