#!/bin/bash

function i() {
    sudo pacman -S --noconfirm "$@"
}
function y() {
    yaourt -S --noconfirm "$@"
}
DOTFILE=${HOME}/.config/dotfile

sudo pacman-key --refresh-keys
# Git
i git

# Keybase
if [[ -z /usr/bin/keybase ]]; then
    y keybase-bin
fi
run_keybase

echo "Connect to keybase"
read -p "Press any key to continue... " -n1 -s

if [[ -z ${HOME}/.config/kb_dotfile ]]; then
    git clone keybase://private/jgsqware/dotfile ${HOME}/.config/kb_dotfile
else
    git --git-dir=$HOME/.config/kb_dotfile/.git --work-tree=$HOME/.config/kb_dotfile pull -r
fi

sudo cp -ar ${HOME}/.config/kb_dotfile/ssh/. ~/.ssh/
chmod 400 ~/.ssh/id_rsa
gpg --import ${HOME}/.config/kb_dotfile/gpg/gpg-private-keys.asc
gpg --import ${HOME}/.config/kb_dotfile/gpg/gpg-public-keys.asc
gpg --import-ownertrust ${HOME}/.config/kb_dotfile/gpg/otrust.txt

ln -sf ${DOTFILE}/.gitconfig ~/.gitconfig
ln -sf ${DOTFILE}/.gitignore_global ~/.gitignore_global
git clone git@github.com:jgsqware/dotfile.git ${DOTFILE}



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
if [[ -z /usr/bin/tmuxinator ]]; then
    y  tmuxinator
fi
ln -fs ${DOTFILE}/tmuxinator ${HOME}/.config/tmuxinator

# Python

i python2 \ 
    python-pip \
    python2-pip

# Neovim

i neovim \
    python2-neovim \
    python-neovim 

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -fs ${DOTFILE}/.vimrc ${HOME}/.vimrc
ln -fs ~/.local/share/nvim/ ${HOME}/.config/nvim/
ln -fs ${DOTFILE}/.vimrc ${HOME}/.config/nvim/init.vim
mkdir -p ${HOME}/.config/nvim/colors
ln -fs ${DOTFILE}/nvim/colors/codedark.vim ${HOME}/.config/nvim/colors/codedark.vim

nvim -c "PlugInstall"

# Go

i go
nvim -c "GoInstallBinaries"
${HOME}/.config/nvim/plugged/youcompleteme/install.py --go-completer

# Software
if [[ -z /usr/bin/enpass ]]; then
    y  enpass-bin
fi

sudo pip install mdv




# Docker

i docker \
    docker-compose

# Kubernetes

#y kubernetes-helm-bin \
    #kubectl-bin

# Firefox

i firefox
