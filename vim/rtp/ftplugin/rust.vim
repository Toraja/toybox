let g:rustfmt_autosave = 1

function! Cdebug() abort
	let l:pj_root = fnamemodify(findfile('Cargo.toml', '.;'), ':p:h')
	let l:binary_name = fnamemodify(l:pj_root, ':t')
	let l:binary_path = l:pj_root . '/target/debug/' . l:binary_name
	execute 'Termdebug ' . l:binary_path
endfunction
command! -buffer Cdebug call Cdebug()

function! CrunIns() abort
	Crun
	startinsert
endfunction
command! -buffer CrunIns call CrunIns()

function! RustToggleBackTrace() abort
	let $RUST_BACKTRACE = !$RUST_BACKTRACE
	echo '$RUST_BACKTRACE = ' . $RUST_BACKTRACE
endfunction
command! -buffer RustToggleBackTrace call RustToggleBackTrace()
