" turn on pathogen
execute pathogen#infect()

" SYNTAX HIGHLIGHTING
colorscheme badwolf   " set default color scheme
syntax enable		      " enable syntax processing
"set background=dark
"let g:solarized_termcolors=256
"let g:solarized_visibility = "high"
"let g:solarized_contrast = "high"
"let g:solarized_termtrans = 1
"colorscheme solarized
set showmatch         " highlight matching bracket, paren, etc.

" CLIPBOARD
set clipboard=unnamed

" RAINBOW PARENS (https://github.com/luochen1990/rainbow)
let g:rainbow_active = 1 " activate rainbow parens
let g:rainbow_conf = {
\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\}

" BACKSPACE BEHAVIOR
set backspace=indent,eol,start

" INDENTATION
set tabstop=2		      " number of spaces per <tab>
set softtabstop=2	    " number of spaces inserted/removed when hitting tab
set expandtab		      " use spaces instead of <tab>
set shiftwidth=2      " auto indent width
filetype plugin indent on    " detect filetypes and load type-specific indentation from ~/.vim/indent/*

" POSITION
set number            " show line numbers
"set cursorline        " mark current line

" SEARCH
set incsearch         " update search as you type
set hlsearch          " highlight search matches

" MISC
set showcmd           " show in progress commands (including leader) in the bottom right
set lazyredraw        " only redraw at the end of a macro

" FOLDING
set foldenable        " enable code folding
set foldlevelstart=99 " default to nothing folded on open
set foldnestmax=10    " don't allow more than 10 nested folds
set foldmethod=indent " identify fold regions based on indentation

" CTRL-P Settings
let g:ctrlp_match_window = 'bottom,order:ttb'   " order from top to bottom
let g:ctrlp_switch_buffer = 0                   " always open in new buffer
let g:ctrlp_working_path_mode = 0               " follow vim working dir
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'  " use silver_searcher to find matching files

" OMNICOMPLETE
set omnifunc=syntaxcomplete#Complete

" use bar cursor even inside tmux (NOT WORKING)
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" KEYBINDINGS

" map semicolon to colon to improve sanity
nnoremap ; :

let mapleader=","     " leader is , instead of \

" map <leader><space> to clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" toggle code folding with <space>
nnoremap <space> za

" highlight last inserted text
nnoremap gV `[v`]

" toggle gundo (graphical view of undo tree)
nnoremap <leader>u :GundoToggle<CR>

" re-source ~/.vimrc with <leader>sv
nnoremap <leader>sv :source $MYVIMRC<CR>

" map silver_searcher plugin to <leader>a
nnoremap <leader>a :Ag<space>

" map NERDTree to Ctrl-n
map <C-n> :NERDTreeToggle<CR>

" expand/contract region with v/Ctrl-v
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" AUTO COMMANDS
augroup configgroup
  autocmd!
  autocmd VimEnter * highlight clear SignColumn
  autocmd BufWritePre *.{rb,yml,js,hbs,html,erb,css,scss,clj},Gemfile,Rakefile,Harrisonfile :call <SID>StripTrailingWhitespaces()

  " run NERDTree if opened with no file
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

  " Evaluate Clojure buffers on load
  autocmd BufRead *.clj try | silent! Require | catch /^Fireplace/ | endtry

  "au VimEnter * RainbowParenthesesToggle
  "au Syntax * RainbowParenthesesLoadRound
  "au Syntax * RainbowParenthesesLoadSquare
  "au Syntax * RainbowParenthesesLoadBraces
augroup END

" BACKUPS
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp     " store backups outside of working dir
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" airline
set laststatus=2
let g:airline_powerline_fonts = 1


" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
  " save last search & cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction

