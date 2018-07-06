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

function gi() {
    if [[ ! -f "${HOME}/go/bin/${1}" ]]; then
        git clone git@github.com:giantswarm/${1}.git ~/go/src/github.com/giantswarm/${1}
        cd ~/go/src/github.com/giantswarm/${1}
        go install
        cd -
    fi
}
if false; then
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
ln -fs ${KB_DOTFILE}/ssh/ ${HOME}/.ssh
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
chsh -s $(which zsh)
fi
i i3
ln -fs $DOTFILE/i3 ~/.config/i3
y xfce4-i3-workspaces-plugin-git
exit
# fzf
i fzf \
    the_silver_searcher

# Tmux    
i tmux \
    xclip 

ln -fs ${DOTFILE}/.tmux.conf ${HOME}/.tmux.conf
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
ln -fs ${HOME}/.local/share/nvim/ ${HOME}/.config/nvim
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
    python2-zeroconf \
    mkchromecast 

i jq \
    rsync \
    transmission-gtk \
    keepass \
    rofi \
    playerctl \
    dnsutils \
    xdg-utils \
    libu2f-host \
    terraform \
    httpie \
    vlc \
    tree  

y spotify \
    dropbox

# AWS cli

p awscli
mkdir ~/.aws
ln -s ${KB_DOTFILE}/aws.config ~/.aws/config
ln -s ${KB_DOTFILE}/aws.credentials ~/.aws/credentials

# Thunar

i thunar \
    thunar-archive-plugin \
    file-roller 

y thunar-dropbox-git


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

sudo wget -O /usr/bin/kubectx https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx && sudo chmod +x /usr/bin/kubectx
sudo wget -O /usr/bin/kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens && sudo chmod +x /usr/bin/kubens
sudo wget -O /usr/bin/utils.bash https://raw.githubusercontent.com/ahmetb/kubectx/master/utils.bash && sudo chmod +x /usr/bin/utils.bash
y minikube

y polybar-git \
    envypn-font \
    siji-git 
ln -fs ${DOTFILE}/polybar ${HOME}/.config/polybar

i ttf-font-awesome \
	i3lock \
        feh \
        gucharmap

i xbindkeys
ln -s $DOTFILE/.xbindkeysrc ${HOME}/.xbindkeysrc

# visual studio code

y code

# VirtualBox
KERNELVERSION=$(uname -r | awk '{split($0,a,"."); print a[1]a[2]}')
i virtualbox "linux${KERNELVERSION}-virtualbox-host-modules"

sudo gpasswd -a `whoami` vboxusers

# OpenVPN
i openvpn
sudo ln -fs ${KB_DOTFILE}/update-resolv-conf.sh /etc/openvpn/update-resolv-conf.sh
chmod +x /etc/openvpn/update-resolv-conf.sh

# giantswarm 
gi gsctl
gi opsctl
ln -fs ${KB_DOTFILE}/gsctl ${HOME}/.config/gsctl


#etcher
#i polkit lxqt-policykit
y etcher

#bluetooth
i    pulseaudio-alsa \
    pulseaudio-bluetooth \
    bluez \
    bluez-libs \
    bluez-utils

code-oss --install-extension patrys.vscode-code-outline
code-oss --install-extension codezombiech.gitignore 
code-oss --install-extension ms-vscode.go 
code-oss --install-extension ms-kubernetes-tools.vscode-kubernetes-tools 
code-oss --install-extension ziyasal.vscode-open-in-github 
code-oss --install-extension christian-kohler.path-intellisense 
code-oss --install-extension emmanuelbeziat.vscode-great-icons
code-oss --install-extension technosophos.vscode-helm
code-oss --install-extension redhat.vscode-yaml
