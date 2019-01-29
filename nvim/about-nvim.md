If nvim cannot find python, run the command below.  
```bash
// Since neovim 0.3.1 (?)
[sudo] pip3 install --upgrade pynvim
// This is for older version
[sudo] pip3 install --upgrade neovim
```
To install `pip3`:
```bash
# Ubuntu
sudo apt-get install python-dev python-pip python3-dev python3-pip
# CentOS (change to approprite version number)
sudo yum install python36-setuptools
sudo easy_install-3.6 pip
```

Add below to `init.vim` so that nvim can load plugins.  
```viml
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" This is for older version of nvim before 0.3.4 (?)
" Use GuiClipboard() for newer version
if has('win32') || has('win64')
  " With this, nvim can use win32yank
  set runtimepath^=$NvimHome/bin
  " This is also needed to use win32yank (bin is included already, just PATH needs to be modified)
  let $PATH = $NvimHome.'\bin'.$PATH
endif
```
