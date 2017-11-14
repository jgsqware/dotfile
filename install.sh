#!/bin/bash

function i() {
    sudo pacman -S --noconfirm "$@"
}
function y() {
    yaourt -S --noconfirm "$@"
}
DOTFILE=${HOME}/.config/dotfile

# Shell

i termite \
    ttf-hack
mkdir -p ${HOME}/.config/termite
ln -fs ${DOTFILE}/termite.config ${HOME}/.config/termite/config
ln -fs ${DOTFILE}/.zshrc ${HOME}/.zshrc

if [[ -z /usr/share/oh-my-zsh ]]; then
	y oh-my-zsh-git 
fi

# fzf
i fzf \
    the_silver_searcher

# Tmux    
i tmux \
    xclip 

ln -fs ${DOTFILE}/.tmux.conf ${HOME}/.tmux.conf

# Neovim

i neovim \
    python2-neovim \
    python-neovim 

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -fs ${DOTFILE}/.vimrc ${HOME}/.vimrc
ln -fs ${DOTFILE}/.vimrc ${HOME}/.config/nvim/init.vim
mkdir -p ${HOME}/.config/nvim/colors
ln -fs ${DOTFILE}/nvim/colors/codedark.vim ${HOME}/.config/nvim/colors/codedark.vim

nvim -c "PlugInstall"

# Go

#i go
#nvim -c "GoInstallBinaries"
#${HOME}/.config/nvim/plugged/youcompleteme/install.py --go-completer

# Software
if [[ -z /usr/bin/enpass ]]; then
    y  enpass-bin

    echo "Copy SSH key from Enpass BEFORE CONTINUING"
    echo "Press Enter to continue"
    read secondyn < /dev/tty
    
    chmod 400 ~/.ssh/id_rsa
    
    echo "Copy gpg key in /tmp from Enpass BEFORE CONTINUING"
    echo "Press Enter to continue"

    gpg --import /tmp/gpg-private-keys.asc
    gpg --import /tmp/gpg-public-keys.asc
    gpg --import-ownertrust /tmp/otrust.txt

    rm -f /tmp/gpg-private-keys.asc /tmp/gpg-public-keys.asc /tmp/otrust.txt
fi

# Git

ln -sf ${DOTFILE}/.gitconfig ~/.gitconfig
ln -sf ${DOTFILE}/.gitignore_global ~/.gitignore_global
