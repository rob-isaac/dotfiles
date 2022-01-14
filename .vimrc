" disable compatibility with vi
set nocompatible

" get rid of that annoying ass bell
set visualbell

" basic settings
filetype plugin on
filetype indent on
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set splitright

" vertical highlight of cursorline
set cursorline
" tabs -> spaces
set expandtab
" keep 5 lines between scroll
set scrolloff=5

" highlight all search results
set hlsearch

" This will ignore case unless specifically searching for case
" Note: can force lowercase search with \C
set ignorecase
set smartcase

" add numbers to lefthand side
set number

" fix namespace indenting for C/C++
set cino=N-s

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly

" Jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" We can enable the mouse if we want
" if has('mouse')
"   set mouse=a
" endif

" If linux then set ttymouse
" let s:uname = system("echo -n \"$(uname)\"")
" if !v:shell_error && s:uname == "Linux" && !has('nvim')
"   set ttymouse=xterm
" endif

" map jj to escape when in insert mode
inoremap jj <Esc>

" yank to end of line
nnoremap Y y$

" better window switching
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" these are necessary for TrueColors to work well
" with TMux
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if stridx(&runtimepath, expand(data_dir)) == -1
  " data_dir is not on runtimepath, add it
  let &runtimepath.=','.data_dir
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
  let myUndoDir = expand(data_dir . '/undodir')
  " Create dirs
  call system('mkdir ' . data_dir)
  call system('mkdir ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif

" Override default python with the one in our path. This allows us to pick
" up on python virtual environments.
let g:python_host_prog = exepath("python")
let g:python3_host_prog = exepath("python3")

" TODO: Re-enable polyglot and figure out how to disable c/c++ highlighting
let g:polyglot_disabled = ['c/c++', 'c++11']

call plug#begin()
Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-tbone'
" Plug 'ap/vim-css-color'
Plug 'preservim/nerdtree'
Plug 'preservim/tagbar'
Plug 'preservim/nerdcommenter'
Plug 'preservim/vimux'
" Plug 'terryma/vim-multiple-cursors'
Plug 'chiel92/vim-autoformat'
Plug 'Raimondi/delimitMate'
Plug 'edkolev/tmuxline.vim'
" Plug 'sheerun/vim-polyglot'
Plug 'prabirshrestha/vim-lsp'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'vim-airline/vim-airline'
Plug 'rakr/vim-one'
Plug 'jpalardy/vim-slime'
Plug 'rob-isaac/vim-slime-cells'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'julienr/vim-cellmode'
call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \| PlugInstall --sync | source $MYVIMRC
      \| endif

" Run Autoformat on save (e.g. clang-format)
au BufWrite *.py,*.cpp,*.h,*.hpp,*.c :Autoformat

" Theme/coloring settings
if (has("termguicolors"))
  set termguicolors
endif
let g:airline_theme='one'
let g:one_allow_italics=1
let g:tmuxline_powerline_separators = 0 " maybe re-enable at somepoint
set background=dark
colorscheme one
highlight Comment cterm=italic gui=italic
call one#highlight('VertSplit','777777','','none')
call one#highlight('Normal','','101010','none')

"------------------------------------------------------------------------------
" slime configuration
"------------------------------------------------------------------------------

" always use tmux
let g:slime_target = 'tmux'

" fix paste issues in ipython
let g:slime_python_ipython = 1

" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1

" set cell delimiter
let g:slime_cell_delimiter = "^\\s*##"
let g:slime_braketed_paste = 1
let g:slime_no_mappings = 1

" slime-cells config
let g:slime_cells_highlight_from = "SpecialComment"

let g:VimuxOrientation = "v"
let g:VimuxCloseOnExit = 1

let s:conda_env = $CONDA_DEFAULT_ENV
let s:ipy_start = "conda activate "  . s:conda_env . "; clear; ipython3"
" TODO: Make sure the runner is running ipython
func! EnsureIPython()
  if !exists('g:VimuxRunnerIndex')
    call VimuxRunCommand(s:ipy_start)
  endif
endfunc

func! CallMake(...)
  let threads = get(a:, 1, 4)
  VimuxRunCommand("make -j " . threads)
endfunc

command -bar -nargs=? Make :call CallMake(<args>)
command -bar StopMake :call VimuxInterruptRunner()
command -bar Inspect :call VimuxInspectRunner()

autocmd FileType python 
  \ nnoremap <silent><expr> <leader>s exists('g:VimuxRunnerIndex')
    \ ? ":call VimuxCloseRunner()\<CR>"
    \ : ":call VimuxRunCommand(s:ipy_start)\<CR>"

autocmd FileType python 
    \ nmap <c-c><c-c> :call EnsureIPython()<CR><Plug>SlimeCellsSendAndGoToNext
autocmd FileType python 
    \ nmap <c-c><c-x> :call EnsureIPython()<CR><Plug>SlimeSendCell
autocmd FileType python 
    \ nmap <c-c><c-j> :call EnsureIPython()<CR><Plug>SlimeCellsNext
autocmd FileType python 
    \ nmap <c-c><c-k> :call EnsureIPython()<CR><Plug>SlimeCellsPrev
autocmd FileType python 
    \ xmap <c-c><c-c> :call EnsureIPython()<CR><Plug>SlimeRegionSend

" COC Settings

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function IsComment()
  return synIDattr(synID(line('.'),col('.')-1,1),'name') =~ 'comment\|string\|character\|doxygen'
endfunction

" enter will select the suggestion and add snippet for it unless we are in a
" comment (in which case we need to tab into suggensions)
inoremap <silent><expr> <cr> pumvisible() ? IsComment() ? "\<CR>" :
      \ coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gs :call CocAction('jumpDefinition', 'vsplit')<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Use ff to perform CocAction and fix warning
nnoremap <silent> ff :CocAction<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

nnoremap cc :CocCommand clangd.switchSourceHeader<CR>

" NERDTree specific mappings.
" Map tn to toggle NERDTree open and close.
nnoremap tn :NERDTreeToggle<cr>

nnoremap tn :tabnext<cr>
nnoremap tp :tabprevious<cr>

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" tagbar toggle
nnoremap tt :TagbarToggle<CR>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" Redirect the output of a Vim or external command into a scratch buffer
" Note: Blocking call
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" Non-blocking function to run the current buffer
function! RunCurBuf()
  if exists("s:job")
    call job_stop(s:job)
    echom "job stopped!"
  endif
	for win in range(1, winnr('$'))
		if getwinvar(win, 'dummy')
			execute win . 'windo close'
		endif
	endfor
  echom "starting job"
  let path = expand('%:p')
  let s:job = job_start(['/bin/bash','-c',path],
        \ {'out_io': 'buffer','err_io': 'out', 'out_name': 'dummy'})
  botright vnew | buffer dummy
  let w:dummy = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  wincmd p
endfunction

" Remap F5 to executing the current buffer
inoremap <silent> <F5> :call RunCurBuf()<CR>
nnoremap <silent> <F5> :call RunCurBuf()<CR>

