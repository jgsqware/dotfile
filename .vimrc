" vim: fdm=marker

if has('nvim')
    set termguicolors
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
    set inccommand=nosplit " Live substitution"
    set background=dark
    set t_Co=256
endif

"General
set mouse=a
set hidden "hide unsaved file instead of closing it. :ls to see it"
set nobackup                 " Don't create annoying backup files
set noerrorbells             " No beeps
set nojoinspaces             " No double space after a dot
set noswapfile               " Don't use swapfile
set nosplitright             " Split vertical windows left bo the current windows
set spellcapcheck=''         " Allow sentences starting with lower letter
set splitbelow               " Split horizontal windows below to the current windows
set matchtime=0
set modeline
autocmd FileType help wincmd H " open help vertically
set wildignore+=*/log/*,*/target/*,*.class     " MacOSX/Linux
set autowrite
"colorscheme base16-oceanicnext
colorscheme  codedark
"set background=light
"colorscheme PaperColor

" search
set ignorecase
set smartcase
set hlsearch

" tabs
set tabstop=8
set shiftwidth=4
set expandtab
set shiftround
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" handle long lines
set number
set wrap
set linebreak
set breakindent
let &showbreak = '↳ '
set textwidth=79
set formatoptions=qrn1
set cursorline
set colorcolumn=100
hi ColorColumn ctermbg=lightgrey

"Keymap

let mapleader = ","
let maplocalleader = ","

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

nnoremap <C-a> ^ 
nnoremap <C-e> $

inoremap <C-a> <Esc>I
inoremap <C-e> <Esc>A
nnoremap <S-h> :bp<CR>
nnoremap <S-l> :bn<CR>
nnoremap <leader>w :bd<CR>
nnoremap <leader>c :lclose<CR>

" Tmux navigator
let g:tmux_navigator_no_mappings = 1
if !empty($TMUX)
    nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <Esc>\ :TmuxNavigatePrevious<cr>
else
    nnoremap <silent> <M-h> <C-w>h
    nnoremap <silent> <M-j> <C-w>j
    nnoremap <silent> <M-k> <C-w>k
    nnoremap <silent> <M-l> <C-w>l
endif

" syntastic 
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" fzf
nnoremap <c-p> :FZF!<CR>

" tagbar
nmap <F3> :TagbarToggle<CR>
let g:tagbar_sort = 0

" vim-go
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }

let g:go_fmt_command = "goimports"

augroup vimgo
    autocmd!

    autocmd FileType go nmap <buffer> <leader>r <Plug>(go-run)
    autocmd FileType go nmap <buffer> <leader>d <Plug>(go-doc)
    autocmd FileType go nmap <buffer> <C-]> <Plug>(go-def)

    autocmd FileType go setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=8

    autocmd BufWritePost *.go :SyntasticCheck
augroup END

let g:tagbar_type_go = {
            \ 'ctagstype' : 'go',
            \ 'kinds'     : [
            \ 'p:package',
            \ 'c:constants',
            \ 'v:variables',
            \ 't:types',
            \ 'n:interfaces',
            \ 'w:fields',
            \ 'e:embedded',
            \ 'm:methods',
            \ 'r:constructor',
            \ 'f:functions'],
            \ 'sro' : '.',
            \ 'kind2scope' : {
            \ 't' : 'ctype',
            \ 'n' : 'ntype'},
            \ 'scope2kind' : {
            \ 'ctype' : 't',
            \ 'ntype' : 'n'},
            \ 'ctagsbin'  : 'gotags',
            \ 'ctagsargs' : '-sort -silent'}

"NerdTree
nnoremap <leader>o :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif 


"nnoremap <leader>o :exe ':silent !opera %'<CR>
"
""Go command
"map <C-n> :cnext<CR>
"map <C-m> :cprevious<CR>
"nnoremap <leader>q :cclose<CR>
"autocmd FileType go nmap <leader>r  <Plug>(go-run)
"autocmd FileType go nmap <leader>t  <Plug>(go-test)
"let g:go_fmt_command = "goimports"
"let g:go_list_type = "quickfix"
"run :GoBuild or :GoTestCompile based on the go file
"function! s:build_go_files()
"  let l:file = expand('%')
"  if l:file =~# '^\f\+_test\.go$'
"    call go#test#Test(0, 1)
"  elseif l:file =~# '^\f\+\.go$'
"    call go#cmd#Build(0)
"  endif
"endfunction
"
"autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>"
"
"let g:go_def_reuse_buffer = 1
"autocmd FileType go nmap <leader>s  <Plug>(go-def-vertical)
"autocmd FileType go nmap <leader>f :GoInfo<CR>
"autocmd FileType go nmap <leader>g :GoDeclsDir<CR>
"let g:go_auto_type_info = 1
"let g:go_auto_sameids = 1
"
"
""ultisnips
"let g:UltiSnipsExpandTrigger = "<nop>"
"let g:ulti_expand_or_jump_res = 0
"function! ExpandSnippetOrCarriageReturn()
"    let snippet = UltiSnips#ExpandSnippetOrJump()
"    if g:ulti_expand_or_jump_res > 0
"        return snippet
"    else
"        return "\<CR>"
"    endif
"endfunction
"inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" Highlight
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1



"Plugins
call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries'}
Plug 'tpope/vim-fugitive'
Plug 'valloric/youcompleteme'
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'yuttie/comfortable-motion.vim'
Plug 'ErichDonGubler/nerdtree-plugin-open-in-file-browser' | Plug 'ErichDonGubler/vim-file-browser-integration'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-syntastic/syntastic'
Plug 'majutsushi/tagbar'
Plug 'NLKNguyen/papercolor-theme'
call plug#end()
