#!/bin/bash

# ***************
# My Linux Init
# ***************

# exit if .vimrc already exists
if [[ -e ~/.vimrc ]]; then
	echo "This script should have run once."
	exit 9
fi

# exit if toybox has been not been cloned
cd ~/toybox &>/dev/null && git status &>/dev/null
if [[ $? -ne 0 ]]; then
	echo 'Clone "toybox" first'
	exit 9
fi

# create symbolic link and wrapper file
echo -e '\n. ~/toybox/bash/bashrc' >> ~/.bashrc
echo -e '\n$include ~/toybox/bash/inputrc' >> ~/.inputrc
echo -e '\nsource ~/toybox/vim/vimrc' >> ~/.vimrc
echo -e '\nsource ~/ToyBox/vim/gvimrc' >> ~/.gvimrc
echo -e '\n/home/mojito/toybox/vimperator/.vimperatorrc' >> ~/.vimperatorrc

ln -s ~/toybox/bash/bin ~/bin
# XXX not good as this creates symlink in toybox dir
# gishdir='~/toybox/git/bin/bash'
# for gish in $(ls $gishdir); do
	# ln -s ${gishdir}/${gish} ~/bin/${gish}
# done
 ln -s ~/toybox/git/.gitconfig .gitconfig
 ln -s ~/toybox/git/.gitignore_global .gitignore_global

# ----- root privilege is required below -----
echo '----- root privilege is required from now on -----'
sleep 1
# change swap
if [[ -e /etc/sysctl.conf ]]; then
	grep 'vm.swappiness = 10' /etc/sysctl.conf &>/dev/null
	if [[ $? -ne 0 ]]; then
		sudo echo -e "\nvm.swappiness = 10" >> /etc/sysctl.conf
	fi
fi

# display packages to install
cat << _EOF_
*** packages to install ***
bash-completion
xclip
_EOF_
