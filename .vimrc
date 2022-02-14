"# INDENTION
set autoindent
set expandtab
filetype plugin indent on
set shiftwidth=2
set shiftround
set tabstop=2
set smarttab
set smartindent

"# SEARCH
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

"# TEXT
set encoding=utf-8
set scrolloff=10
syntax enable

"# UI
set wildmenu

"# OPTIONS
set autoread
set history=10000
set undolevels=1000000
set wildignore=*.swp,*.pyc,*.class
set pastetoggle=<F11>
set mps+=<:>
set t_Co=24

au FileType python setl sw=2 sts=2 et
au FileType javascript setl sw=2 sts=2 et

map <C-o> :tabe
map <space> <C-f>
map <backspace> <C-b>
map <tab> :tabnext<cr>
map <s-tab> :tabprevious<cr>

function InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
  return "\<tab>"
  else
  return "\<c-p>"
  endif
  endfunction
  inoremap <tab> <c-r>=InsertTabWrapper()<cr>

  iab exx except Exception, ss:
  au BufReadPost *.nginx set syntax=nginx
  au BufReadPost *.apache set syntax=apache
