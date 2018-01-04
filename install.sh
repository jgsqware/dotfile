#!/bin/bash
set -euo pipefail

function i() {
    sudo pacman -S --noconfirm "$@"
}
function y() {
    yaourt -S --noconfirm "$@"
}
DOTFILE=${HOME}/.config/dotfile
KB_DOTFILE=${HOME}/.config/kb_dotfile

export XDG_CONFIG_HOME="${HOME}/.config"

function p(){
    pip install "$1" --user --upgrade
}

sudo pacman-key --refresh-keys
# Git
i git \
    openssh \
    cmake

# yaourt
if [[ ! -f /usr/bin/yaourt ]]; then
    sudo pacman -S --needed base-devel git wget yajl
    git clone https://aur.archlinux.org/package-query.git
    cd package-query/
    makepkg -si --noconfirm
    cd ..
    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt/
    makepkg -si --noconfirm
    cd ..
    sudo rm -dR yaourt/ package-query/
fi

# Opera

i opera \
    mplayer

wget https://repo.herecura.eu/herecura/x86_64/opera-ffmpeg-codecs-62.0.3202.89-1-x86_64.pkg.tar.xz -O codecs.tar.xz
tar xf codecs.tar.xz
sudo mkdir /usr/lib64/opera/lib_extra
sudo mv ./usr/lib/opera/lib_extra/libffmpeg.so /usr/lib64/opera/lib_extra/libffmpeg.so

if [[ ! -f /usr/bin/enpass ]]; then
    y  enpass-bin
fi

# Keybase
if [[ ! -f /usr/bin/keybase ]]; then
    y keybase-bin
fi
run_keybase

echo "Connect to keybase"
read -p "Press any key to continue... " -n1 -s

if [[ ! -d ${KB_DOTFILE} ]]; then
    git clone keybase://private/jgsqware/dotfile ${KB_DOTFILE} 
else
    git --git-dir=${KB_DOTFILE} --work-tree=${KB_DOTFILE} pull -r
fi

rm -rf ${HOME}/.ssh
ln -fs ${KB_DOTFILE}/ssh/ ${HOME}/.ssh/
chmod 400 ${HOME}/.ssh/id_rsa
gpg --import ${KB_DOTFILE}/gpg/gpg-private-keys.asc
gpg --import ${KB_DOTFILE}/gpg/gpg-public-keys.asc
gpg --import-ownertrust ${KB_DOTFILE}/gpg/otrust.txt

if [[ ! -d ${HOME}/.config/dotfile ]]; then
    git clone git@github.com:jgsqware/dotfile.git ${DOTFILE}
else
    git --git-dir=${HOME}/.config/dotfile/.git --work-tree=${HOME}/.config/dotfile pull -r
fi
ln -sf ${KB_DOTFILE}/.gitconfig ${HOME}/.gitconfig
ln -sf ${KB_DOTFILE}/.gitignore_global ${HOME}/.gitignore_global



# Shell

sudo pacman -S termite
i ttf-hack
mkdir -p ${HOME}/.config/termite
ln -fs ${DOTFILE}/termite/termite.config ${HOME}/.config/termite/config
ln -fs ${DOTFILE}/.zshrc ${HOME}/.zshrc

if [[ ! -d /usr/share/oh-my-zsh ]]; then
	y oh-my-zsh-git 
fi

# fzf
i fzf \
    the_silver_searcher

# Tmux    
i tmux \
    xclip 

ln -fs ${DOTFILE}/.tmux.conf ${HOME}/.tmux.conf
if [[ ! -f /usr/bin/tmuxinator ]]; then
    y  tmuxinator
fi
ln -fs ${DOTFILE}/tmuxinator ${HOME}/.config/tmuxinator
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

# Python

i python2 \
    python2-pip \
    python-pip

# Neovim

i neovim \
    python2-neovim \
    python-neovim 

y universal-ctags-git

curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -fs ${DOTFILE}/.vimrc ${HOME}/.vimrc
ln -fs ${HOME}/.local/share/nvim/ ${HOME}/.config/nvim/
ln -fs ${DOTFILE}/.vimrc ${HOME}/.config/nvim/init.vim
mkdir -p ${HOME}/.config/nvim/colors
ln -fs ${DOTFILE}/nvim/colors/codedark.vim ${HOME}/.config/nvim/colors/codedark.vim

nvim -c "PlugInstall|qa"

# Go

i go
nvim -c "GoInstallBinaries|qa"
${HOME}/.config/nvim/plugged/youcompleteme/install.py --go-completer

# Software

p mdv \
    yq \
    p7zip

y xreader \
    mkchromecast \

i jq \
    rsync \
    transmission-gtk \
    libreoffice-fresh \
    keepass \
    rofi \
    playerctl \
    dnsutils \
    spotify \
    xdg-utils \
    libu2f-host \
    terraform

# AWS cli

p awscli
mkdir ~/.aws
ln -s ${KB_DOTFILE}/aws.config ~/.aws/config
ln -s ${KB_DOTFILE}/aws.credentials ~/.aws/credentials

# Thunar

i thunar \
    thunar-archive-plugin \
    file-roller


# Docker

i docker \
    docker-compose

# Kubernetes

if [[ ! -f /usr/bin/helm ]]; then
    y kubernetes-helm-bin
    wget -O /tmp/helm-v2.6.2-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.6.2-linux-amd64.tar.gz
    tar xvf /tmp/helm-v2.6.2-linux-amd64.tar.gz
    sudo mv linux-amd64/helm /usr/bin/helm_2.6.2
    rm -rf /tmp/helm-v2.6.2-linux-amd64.tar.gz linux-amd64
fi

if [[ ! -f /usr/bin/kubectl ]]; then
    y kubectl-bin
fi

# bspwm

if $(sudo pacman -Q | grep -q bspwm); then
    ln -fs ${DOTFILE}/bspwm ${HOME}/.config/bspwm
    ln -fs ${DOTFILE}/sxhkd ${HOME}/.config/sxhkd

    y polybar \
        envypn-font \
        siji-git 
    ln -fs ${DOTFILE}/polybar ${HOME}/.config/polybar
    
    i ttf-font-awesome \
	i3lock
fi

# plexmediaserver

y plex-media-server

# visual studio code

y visual-studio-code

# gdrive 
if [[ ! -f /usr/bin/drive ]]; then
    y drive
    drive init ${HOME}/gdrive
    cd gdrive
    drive pull
    cd -
fi

# VirtualBox

i virtualbox \
    virtualbox-host-modules-arch \
    linux-headers \ 
    linux-lts

# OpenVPN
i openvpn
sudo ln -fs ${KB_DOTFILE}/update-resolv-conf.sh /etc/openvpn/update-resolv-conf.sh
chmod +x /etc/openvpn/update-resolv-conf.sh
