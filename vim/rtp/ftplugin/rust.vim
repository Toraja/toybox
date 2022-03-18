let g:rustfmt_autosave = 1

function! Croot() abort
  return fnamemodify(findfile('Cargo.toml', '.;'), ':p:h')
endfunction

function! Cdebug() abort
  let l:pj_root = Croot()
  let l:binary_name = fnamemodify(l:pj_root, ':t')
  let l:binary_path = l:pj_root . '/target/debug/' . l:binary_name
  if !filereadable(l:binary_path)
    echohl WarningMsg | echo 'Binary does not exist. Try building the modlue first.' | echohl NONE
    return
  endif
  execute 'Termdebug ' . l:binary_path
endfunction
command! -buffer Cdebug call Cdebug()

function! CrunIns(args) abort
  execute 'Crun ' . a:args
  startinsert
endfunction
command! -buffer -nargs=* CrunIns call CrunIns(<q-args>)

function! RustToggleBackTrace() abort
  let $RUST_BACKTRACE = !$RUST_BACKTRACE
  echo '$RUST_BACKTRACE = ' . $RUST_BACKTRACE
endfunction
command! -buffer RustToggleBackTrace call RustToggleBackTrace()


" {{{ || neomake || ---
let g:neomake_rust_enabled_makers = []
" --- || neomake || }}}"
