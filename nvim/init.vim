source $HOME/.config/nvim/plugin_init.vim

set termguicolors                  " Enable GUI colors for the terminal to get truecolor

filetype plugin indent on
syntax enable

if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif

" This must be loaded after we set termguicolors
lua require('init')

let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

autocmd BufEnter,BufWritePost *.rs lua require('lsp_extensions.inlay_hints').request { aligned = true, prefix = " » " }

let g:os = substitute(system('uname'), "\n", "", "")

" Settings
set number relativenumber
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set noshowmode                  " We show the mode with airlien or lightline
set noerrorbells                " No beeps
set visualbell
set relativenumber
set showcmd                     " Show me what I'm typing
set ignorecase
set smartcase
set mouse+=a
set autoindent
set hidden
set splitright                  " Split vertical windows right to the current windows
set splitbelow                  " Split horizontal windows below to the current windows
au FocusLost * :wa              " Set vim to save the file on focus out.
set backspace=indent,eol,start  " Makes backspace key more powerful.

command! -nargs=* -complete=help Help vertical belowright help <args>
autocmd FileType help wincmd L

" WildMenu completetion
set wildmenu
set wildmode=list:full
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=go/pkg                           " Go static files
set wildignore+=go/bin                           " Go bin files
set wildignore+=*.pyc                            " Python byte code

" Text Options
set wrap
set textwidth=79
set formatoptions=qrn1

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

" Jump to valid line
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \	exe "normal! g`\"" |
      \ endif

" never do this again --> :set paste <ctrl-v> :set no paste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

" Netrw settings
let g:netrw_liststyle = 3
let g:netrw_browse_split = 1
let g:netrw_winsize = 25 "??
