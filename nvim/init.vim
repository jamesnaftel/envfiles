source $HOME/.config/nvim/plugin_init.vim

"require(lspconfig)
set termguicolors                  " Enable GUI colors for the terminal to get truecolor

filetype plugin indent on    " required
syntax enable

" This must be loaded after we set termguicolors
lua require('lspconfig')

set completeopt=menuone,noinsert,noselect
set shortmess+=c

let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

nnoremap <silent> <leader>q :Sayonara<CR>

lua require'lspconfig'.rust_analyzer.setup({on_attach=require'completion'.on_attach})
lua require'lspconfig'.pyls.setup{}
lua require'lspconfig'.terraformls.setup{}
lua require'colorizer'.setup()

set completeopt-=preview
"autocmd BufEnter * lua require'completion'.on_attach()

autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \	exe "normal! g`\"" |
      \ endif

nmap <leader>w :w!<cr>

" Close quickfix easily
nnoremap <leader>a :cclose<CR>

" Remove search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Center the screen
nnoremap <space> zz

" Do not show stupid q: window
map q: :q

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

nnoremap <F6> :setlocal spell! spell?<CR>

" Settings
set noshowmode                  " We show the mode with airlien or lightline
set noerrorbells                " No beeps
set visualbell
set number                      " Show line numbers
set showcmd                     " Show me what I'm typing
set ignorecase
set smartcase
set ruler
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

" Just go out in insert mode
imap jk <ESC>l
imap JK <ESC>l

" never do this again --> :set paste <ctrl-v> :set no paste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

" Netrw settings
let g:netrw_liststyle = 3
let g:netrw_browse_split = 1
let g:netrw_winsize = 25 "??

" Lightline settings
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste'],
      \             [ 'fugitive', 'filename', 'modified', 'ctrlpmark' ],
      \             [ 'go'] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'go'] ],
      \ },
      \ 'component_function': {
      \   'modified': 'LightLineModified',
      "\   'filename': 'LightLineFilename',
      \   'go': 'LightLineGo',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'fugitive': 'LightLineFugitive',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ }

function! LightLineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineInfo()
  return winwidth(0) > 60 ? printf("%3d:%-2d", line('.'), col('.')) : ''
endfunction

function! LightLinePercent()
  return &ft =~? 'vimfiler' ? '' : (100 * line('.') / line('$')) . '%'
endfunction

function! LightLineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! LightLineGo()
  " return ''
  return exists('*go#jobcontrol#Statusline') ? go#jobcontrol#Statusline() : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == 'ControlP' ? 'CtrlP' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  if mode() == 't'
    return ''
  endif

  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]')
endfunction

if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif
