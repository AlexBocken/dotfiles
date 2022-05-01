let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'lukesmithxyz/vimling'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'commit': '2ad659d8b1a3d7bef7dca7d33c6ab9363a729100', 'do': 'yarn install --frozen-lockfile'}
Plug 'ap/vim-css-color'
Plug 'lervag/vimtex'
Plug 'arcticicestudio/nord-vim'
Plug 'rhysd/vim-grammarous'
Plug 'da-h/AirLatex.vim', {'do': ':UpdateRemotePlugins'}
call plug#end()

set title
set bg=light
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd

colorscheme nord

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber

" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif

" AirLatex
" your login-name
let g:AirLatexUsername="cookies:overleaf_session2=s%"

" optional: set server name
let g:AirLatexDomain="www.overleaf.com"

let g:AirLatexAllowInsecure=0

" vimtex:
let g:vimtex_compiler_latexmk = { 'build_dir' : '',
			\ 'callback' : 1,
			\ 'continuous' : 1,
			\ 'executable' : 'latexmk',
			\ 'hooks' : [],
			\ 'options' : [
			\   '-pdflatex="pdflatex --shell-escape %O %S"',
			\   '-verbose',
			\   '-file-line-error',
			\   '-synctex=1',
			\   '-interaction=nonstopmode',
			\ ],
			\}


" vimling:
	"nm <leader><leader>d :call ToggleDeadKeys()<CR>
	"imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
	"nm <leader><leader>i :call ToggleIPA()<CR>
	"imap <leader><leader>i <esc>:call ToggleIPA()<CR>a
	"nm <leader><leader>q :call ToggleProse()<CR>

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" start browser-sync for easier refresh with web-dev
	nnoremap <leader>bs :!browser-sync start --server --files . > /dev/null 2>&1 &<CR>
" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
 	autocmd BufWritePre * let currPos = getpos(".")
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
	autocmd BufWritePre *.[ch] %s/\%$/\r/e
  	autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Navigating with guides
	inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
	vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
	map <leader><leader> <Esc>/<++><Enter>"_c4l


" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>
"""LATEX
	" Word count:
	autocmd FileType tex map <leader>w :w !detex \| wc -w<CR>
	" Code snippets
	"""autocmd FileType tex inoremap	,fr \begin{frame}<Enter>\frametitle{}<Enter><Enter><++><Enter><Enter>\end{frame}<Enter><Enter><++><Esc>6kf}i
	autocmd FileType tex inoremap	,fi \begin{fitch}<Enter><Enter>\end{fitch}<Enter><Enter><++><Esc>3kA
	autocmd FileType tex inoremap	,exe \begin{exe}<Enter>\ex<Space><Enter>\end{exe}<Enter><Enter><++><Esc>3kA
	autocmd FileType tex inoremap	,bf \textbf{}<++><Esc>T{i
	autocmd FileType tex vnoremap 	, <ESC>`<i\{<ESC>`>2la}<ESC>?\\{<Enter>a
	autocmd FileType tex inoremap	,it \textit{}<++><Esc>T{i
	autocmd FileType tex inoremap	,ct \textcite{}<++><Esc>T{i
	autocmd FileType tex inoremap	,cp \parencite{}<++><Esc>T{i
	autocmd FileType tex inoremap	,glos {\gll<Space><++><Space>\\<Enter><++><Space>\\<Enter>\trans{``<++>''}}<Esc>2k2bcw
	autocmd FileType tex inoremap	,x \begin{xlist}<Enter>\ex<Space><Enter>\end{xlist}<Esc>kA<Space>
	autocmd FileType tex inoremap	,ol \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
	autocmd FileType tex inoremap	,ul \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
	autocmd FileType tex inoremap	,li <Enter>\item[]<Space>
	autocmd FileType tex inoremap	,ref \ref{}<Space><++><Esc>T{i
	autocmd FileType tex inoremap	,tab \begin{tabular}<Enter><++><Enter>\end{tabular}<Enter><Enter><++><Esc>4kA{}<Esc>i
	autocmd FileType tex inoremap	,ot \begin{tableau}<Enter>\inp{<++>}<Tab>\const{<++>}<Tab><++><Enter><++><Enter>\end{tableau}<Enter><Enter><++><Esc>5kA{}<Esc>i
	autocmd FileType tex inoremap	,can \cand{}<Tab><++><Esc>T{i
	autocmd FileType tex inoremap	,con \const{}<Tab><++><Esc>T{i
	autocmd FileType tex inoremap	,v \vio{}<Tab><++><Esc>T{i
	autocmd FileType tex inoremap	,a \href{}{<++>}<Space><++><Esc>2T{i
	autocmd FileType tex inoremap	,sc \textsc{}<Space><++><Esc>T{i
	autocmd FileType tex inoremap	,chap \chapter{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap	,sec \section{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap	,ssec \subsection{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap	,sssec \subsubsection{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap	,st <Esc>F{i*<Esc>f}i
	autocmd FileType tex inoremap	,beg \begin{DELRN}<Enter><++><Enter>\end{DELRN}<Enter><Enter><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<Enter>c
	autocmd FileType tex inoremap	,up <Esc>/usepackage<Enter>o\usepackage{}<Esc>i
	autocmd FileType tex nnoremap 	,up /usepackage<Enter>o\usepackage{}<Esc>i
	autocmd FileType tex inoremap	,tt \texttt{}<Space><++><Esc>T{i
	autocmd FileType tex inoremap	,bt {\blindtext}
	autocmd FileType tex inoremap	,nu $\varnothing$
	autocmd FileType tex inoremap	,col \begin{columns}[T]<Enter>\begin{column}{.5\textwidth}<Enter><Enter>\end{column}<Enter>\begin{column}{.5\textwidth}<Enter><++><Enter>\end{column}<Enter>\end{columns}<Esc>5kA
	autocmd FileType tex inoremap	,rn (\ref{})<++><Esc>F}i
	autocmd FileType tex inoremap	,fr \dfrac{}{<++>} <++> <Esc>T{2hi
	autocmd FileType tex inoremap	,sqrt \sqrt{}<++> <Esc>T{i
	autocmd FileType tex inoremap	,b( \left(\right)<++><Esc>T(i
	autocmd FileType tex inoremap	,bb \mathbb{}<++><Esc>T{i
 	autocmd FileType tex inoremap	,b{ \left\{\right\}<++><Esc>T{i
	autocmd FileType tex inoremap	,b[ \left[\right]<++><Esc>T[i
	autocmd FileType tex inoremap	,rm \mathrm{}<++><Esc>T{i
 	autocmd FileType tex inoremap	,abs \left\|\right\|<++><Esc>3ba
 	autocmd FileType tex inoremap	,em \emph{}<++><Esc>T{i
	autocmd FileType tex inoremap 	,tabb \begin{tabbing}<Enter>\hspace*{3cm}\=\hspace*{3cm}\= \kill<Enter>\end{tabbing}<Enter><Enter><++><Esc>3kA<Enter>
	autocmd FileType tex inoremap 	,txt  \text{}<++><Esc>T{i
	autocmd FileType tex inoremap 	,sfr  \sfrac{}{<++>}<++><Esc>2T{i




"""HTML
	autocmd FileType html inoremap	,b <b></b><Space><++><Esc>FbT>i
	autocmd FileType html inoremap	,it <em></em><Space><++><Esc>FeT>i
	autocmd FileType html inoremap	,1 <h1></h1><Enter><Enter><++><Esc>2kf<i
	autocmd FileType html inoremap	,2 <h2></h2><Enter><Enter><++><Esc>2kf<i
	autocmd FileType html inoremap	,3 <h3></h3><Enter><Enter><++><Esc>2kf<i
	autocmd FileType html inoremap	,p <p></p><Enter><Enter><++><Esc>02kf>a
	autocmd FileType html inoremap	,a <a<Space>href=""><++></a><Space><++><Esc>14hi
	autocmd FileType html inoremap	,e <a<Space>target="_blank"<Space>href=""><++></a><Space><++><Esc>14hi
	autocmd FileType html inoremap	,ul <ul><Enter><li></li><Enter></ul><Enter><Enter><++><Esc>03kf<i
	autocmd FileType html inoremap	,li <Esc>o<li></li><Esc>F>a
	autocmd FileType html inoremap	,ol <ol><Enter><li></li><Enter></ol><Enter><Enter><++><Esc>03kf<i
	autocmd FileType html inoremap	,im <img src="" alt="<++>"><++><esc>Fcf"a
	autocmd FileType html inoremap	,td <td></td><++><Esc>Fdcit
	autocmd FileType html inoremap	,tr <tr></tr><Enter><++><Esc>kf<i
	autocmd FileType html inoremap	,th <th></th><++><Esc>Fhcit
	autocmd FileType html inoremap	,tab <table><Enter></table><Esc>O
	autocmd FileType html inoremap	,gr <font color="green"></font><Esc>F>a
	autocmd FileType html inoremap	,rd <font color="red"></font><Esc>F>a
	autocmd FileType html inoremap	,yl <font color="yellow"></font><Esc>F>a
	autocmd FileType html inoremap	,dt <dt></dt><Enter><dd><++></dd><Enter><++><esc>2kcit
	autocmd FileType html inoremap	,dl <dl><Enter><Enter></dl><enter><enter><++><esc>3kcc
	"autocmd FileType html inoremap &<space> &amp;<space>
	autocmd FileType html inoremap ,fr <sup></sup>&frasl;<sub><++></sub><++><esc>2T/2hi
	autocmd FileType html inoremap ,o<space> <i><sup>⚬</sup></i>
	autocmd FileType html inoremap ,cr <i><sup>♱</sup></i>
	autocmd FileType html inoremap ,pl <p lang=la></p><esc>Taa
	autocmd FileType html inoremap ,pd <p lang=de></p><esc>Tea
	autocmd FileType html inoremap ,dg °C
	"autocmd FileType html inoremap á &aacute;
	"autocmd FileType html inoremap é &eacute;
	"autocmd FileType html inoremap í &iacute;
	"autocmd FileType html inoremap ó &oacute;
	"autocmd FileType html inoremap ú &uacute;
	"autocmd FileType html inoremap ä &auml;
	"autocmd FileType html inoremap ë &euml;
	"autocmd FileType html inoremap ï &iuml;
	"autocmd FileType html inoremap ö &ouml;
	"autocmd FileType html inoremap ü &uuml;
	"autocmd FileType html inoremap ã &atilde;
	"autocmd FileType html inoremap ẽ &etilde;
	"autocmd FileType html inoremap ĩ &itilde;
	"autocmd FileType html inoremap õ &otilde;
	"autocmd FileType html inoremap ũ &utilde;
	"autocmd FileType html inoremap ñ &ntilde;
	"autocmd FileType html inoremap à &agrave;
	"autocmd FileType html inoremap è &egrave;
	"autocmd FileType html inoremap ì &igrave;
	"autocmd FileType html inoremap ò &ograve;
	"autocmd FileType html inoremap ù &ugrave;


""".bib
	autocmd FileType bib inoremap	,a @article{<Enter>author<Space>=<Space>{<++>},<Enter>year<Space>=<Space>{<++>},<Enter>title<Space>=<Space>{<++>},<Enter>journal<Space>=<Space>{<++>},<Enter>volume<Space>=<Space>{<++>},<Enter>pages<Space>=<Space>{<++>},<Enter>}<Enter><++><Esc>8kA,<Esc>i
	autocmd FileType bib inoremap	,b @book{<Enter>author<Space>=<Space>{<++>},<Enter>year<Space>=<Space>{<++>},<Enter>title<Space>=<Space>{<++>},<Enter>publisher<Space>=<Space>{<++>},<Enter>}<Enter><++><Esc>6kA,<Esc>i
	autocmd FileType bib inoremap	,c @incollection{<Enter>author<Space>=<Space>{<++>},<Enter>title<Space>=<Space>{<++>},<Enter>booktitle<Space>=<Space>{<++>},<Enter>editor<Space>=<Space>{<++>},<Enter>year<Space>=<Space>{<++>},<Enter>publisher<Space>=<Space>{<++>},<Enter>}<Enter><++><Esc>8kA,<Esc>i

"MARKDOWN
	autocmd Filetype markdown,rmd map <leader>w yiWi[<esc>Ea](<esc>pa)
	autocmd Filetype markdown,rmd inoremap	,n ---<Enter><Enter>
	autocmd Filetype markdown,rmd inoremap	,b ****<++><Esc>F*hi
	autocmd Filetype markdown,rmd inoremap	,s ~~~~<++><Esc>F~hi
	autocmd Filetype markdown,rmd inoremap	,e **<++><Esc>F*i
	autocmd Filetype markdown,rmd inoremap	,h ====<Space><++><Esc>F=hi
	autocmd Filetype markdown,rmd inoremap	,i ![](<++>)<++><Esc>F[a
	autocmd Filetype markdown,rmd inoremap	,a [](<++>)<++><Esc>F[a
	autocmd Filetype markdown,rmd inoremap	,1 #<Space><Enter><++><Esc>kA
	autocmd Filetype markdown,rmd inoremap	,2 ##<Space><Enter><++><Esc>kA
	autocmd Filetype markdown,rmd inoremap	,3 ###<Space><Enter><++><Esc>kA
	autocmd Filetype markdown,rmd inoremap	,l --------<Enter>
	autocmd Filetype markdown,rmd inoremap	,r ```{r}<CR>```<CR><CR><esc>2kO
	autocmd Filetype markdown,rmd inoremap	,p ```{python}<CR>```<CR><CR><esc>2kO
	autocmd Filetype mardown,rmd inoremap	,c ```<cr>```<cr><cr><esc>2kO

""".xml
	autocmd FileType xml inoremap	,e <item><Enter><title><++></title><Enter><guid<space>isPermaLink="false"><++></guid><Enter><pubDate><Esc>:put<Space>=strftime('%a, %d %b %Y %H:%M:%S %z')<Enter>kJA</pubDate><Enter><link><++></link><Enter><description><![CDATA[<++>]]></description><Enter></item><Esc>?<title><enter>cit
	autocmd FileType xml inoremap	,a <a href="<++>"><++></a><++><Esc>F"ci"


"""I like COC
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
	\ "\<tab>"
inoremap <expr><S-tab> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> pumvisible() ?  coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

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

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

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

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

inoremap <silent><expr> <NUL> coc#refresh()
