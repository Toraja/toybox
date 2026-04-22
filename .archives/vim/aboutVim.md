# About

## 64-bit for windows
Available on the websites below
- https://github.com/vim/vim-win32-installer (offcial? version slightly ahead)
- https://tuxproject.de/projects/vim/ (unofficial)

## Japanese support
Add below to vimrc  
Setting `encoding` option fixes garbled characters, but breaks all keybindings with Meta key.  
To avoid this, it must be placed before any keymapping.  
```viml
set encoding=utf-8	" this fixes garbled characters
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
```

## Python support
The version of installed python must be the same as the one that `:version` displays.  
`Compilation:` -> `-DDYNAMIC_PYTHON_DLL` or `-DDYNAMIC_PYTHON3_DLL`

Python executable must be added to `PATH`.  
For windows vim, setting up `PATH` for pythonXX.dll (XX is version) might not be enough.  
In such case, add an environment variable `PYTHON_HOME` and set it to the directory in which the
dll is located.  

## Plugin

### Installing YouCompleteMe
- When you compile the `ycm_core` library that YCM needs using `cmake`, an error might occur saying
  `PYTHON_INCLUDE_DIR` and `PYTHON_LIBRARY` are missing. In that case, add options
  `-DPYTHON_INCLUDE_DIR=$PYTHON_HOME/include` and `-DPYTHON_LIBRARY=$PYTHON_HOME/libs/pythonXX.lib`
  (where `XX` is version number).

### deoplete-go  
- <mark>NOTE</mark> This seems not necessary  
  On windows, install using cygwin (simply run `make` in the plugin root dir)  
  The line below (37?) in makefile fails so ~~comment it out~~ delete the line temporarily.  
  (Commenting stops the execution of make. Seems working ok)  
  `mv "$(CURRENT)/build/ujson."*".so" "$(TARGET)"`
- Run `go get -u github.com/nsf/gocode` and files will be installed in `$HOME/go` (unless you have
  set `$GOPATH` to different location).  
  Set $GOPATH as environment variable. (or add `$GOPATH/bin` to `$PATH` then you don't need to set
  `g:deoplete#sources#go#gocode_binary`)  
- Add below to vimrc/ftplugin  
  ```viml
  let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'   " 'gocode.exe' for windows
  let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
  ```
- Map `deoplete#manual_complete()` to a key you like so that you can invoke completion manually.  
  For example:  
  `inoremap <silent> <expr> <C-i> pumvisible() ? "\<C-n>" : deoplete#manual_complete()`

## Misc
- Vim does not show help...
  Because there was no 'doc' directory containing help files under $VIMRUNTIME directory  
- Insert Mode Shortcuts  
  :help ins-special-keys  
- Insert completion  
  :help ins-completion  
- Make Vim use OS clipboard by default  
  `set clipboard=unnamed`  
- Enable mouse  
  `set mouse=a`  
  X support is required. `:echo has('x11')` returns 1 if supported.  
- Use `inputsave()` and `inputrestore()` for keymaps that take user input  
  When you use a function that calls user-prompting function such as `getchar()` or `input()`
  with your keymap, keystroke after the function is consumed by that.  
  To prevent that, wrap the user-prompting commands with inputsave() and inputrestore().  
  ```vim
  function! TellMe()
  echo 'Tell me something'
  call inputsave()
  let l:userinput = input("I'm listening... ")
  call inputrestore()
  echo 'Your input is '. l:userinput
  endfunction

  nnoremap <F10> :echo 'pre-function'<CR>:call TellMe()<CR>:echo 'post-function'<CR>
  ```
