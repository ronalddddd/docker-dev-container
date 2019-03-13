set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" NERDTree file browser
Plugin 'scrooloose/nerdtree'

" Fuzzy file open/finder
Plugin 'kien/ctrlp.vim'

" Multi-cursor
Plugin 'terryma/vim-multiple-cursors'

" git wrapper
Plugin 'tpope/vim-fugitive'

" Syntax and Auto-complete stuff
Plugin 'jiangmiao/auto-pairs'
Plugin 'vim-syntastic/syntastic'
Plugin 'Valloric/YouCompleteMe'

" Themes and stuff
Plugin 'joshdick/onedark.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" HTML shortcuts
Plugin 'rstacruz/sparkup'

" Prettier
Plugin 'prettier/vim-prettier'

" TypeScript
" Syntax Highlighting
Plugin 'leafgarland/typescript-vim'
" Code completion, navigate, show where symbol is referenced, etc...
Plugin 'Quramy/tsuquyomi'
" Syntax Highlighting for template strings
Plugin 'Quramy/vim-js-pretty-template'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Encoding
set encoding=utf-8

" Cursor
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

" Line numbers
set relativenumber
set number

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Color Scheme
set t_Co=256
set background=dark
colorscheme PaperColor
let g:airline_theme='papercolor'

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'eslint .'

" Key Mappings
" NERDTree Hotkey
map <silent> <C-o> :NERDTreeFocus<CR>

" Auto file reload
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

