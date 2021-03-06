#!/bin/bash
set -euo pipefail

function xpacman() {
    sudo pacman -S --noconfirm "$@" --needed --quiet
}
function fpacman() {
    (
        set +o pipefail
        yes y | sudo pacman -S "$@" --needed --quiet
    )
}
function xyay() {
        yay -S --noconfirm "$@" --needed --noredownload --norebuild --quiet
}
DOTFILE=${HOME}/.config/dotfile
KB_DOTFILE=${HOME}/.config/kb_dotfile

export XDG_CONFIG_HOME="${HOME}/.config"

function xpip(){
    pip install "$1" --user --upgrade
}

function gi() {
    if [[ ! -f "${HOME}/go/bin/${1}" ]]; then
        (
            git clone git@github.com:giantswarm/"${1}.git" ~/go/src/github.com/giantswarm/"${1}"
            cd ~/go/src/github.com/giantswarm/"${1}"
            go install
        )
    fi
}

### Set Locale to en_US.UTF-8 ###
localectl set-locale LANG=en_US.UTF-8
unset LANG
source /etc/profile.d/locale.sh

xyay    brave-bin \
        enpass-bin \

SSHKEY="/tmp/id_rsa"
echo "Configure Enpass and put ssh key in ${SSHKEY}"

read -p "Press any key to continue... " -n1 -s

echo ""

if [[ ! -d ${KB_DOTFILE} ]]; then
    ssh-agent bash -c "ssh-add ${SSHKEY}; git clone git@github.com:jgsqware/kb_dotfile.git ${KB_DOTFILE}"  
else
    (
        cd ${KB_DOTFILE}
        ssh-agent bash -c "ssh-add ${SSHKEY}; git stash"          
        ssh-agent bash -c "ssh-add ${SSHKEY}; git pull -r"  
        ssh-agent bash -c "ssh-add ${SSHKEY}; git stash pop" || echo   

    )
fi

if [[ ! -d ${DOTFILE} ]]; then
    ssh-agent bash -c "ssh-add ${SSHKEY}; git clone git@github.com:jgsqware/dotfile.git ${DOTFILE}"  
else
    (
        cd "${DOTFILE}"
        ssh-agent bash -c "ssh-add ${SSHKEY}; git stash"          
        ssh-agent bash -c "ssh-add ${SSHKEY}; git pull -r"  
        ssh-agent bash -c "ssh-add ${SSHKEY}; git stash pop" || echo
    )
fi

rm -rf ${HOME}/.ssh
ln -fs ${KB_DOTFILE}/ssh/ ${HOME}/.ssh
chmod 400 ${HOME}/.ssh/id_rsa
chmod 644 ${HOME}/.ssh/id_rsa.pub
gpg --import ${KB_DOTFILE}/gpg/gpg-private-keys.asc
gpg --import ${KB_DOTFILE}/gpg/gpg-public-keys.asc
gpg --import-ownertrust ${KB_DOTFILE}/gpg/otrust.txt

ln -sf ${KB_DOTFILE}/.gitconfig ${HOME}/.gitconfig
ln -sf ${KB_DOTFILE}/.gitignore_global ${HOME}/.gitignore_global

xpacman openssh \
        mplayer \
        cmake \
        termite \
        ttf-hack \
        ttf-dejavu \
        fzf \
        the_silver_searcher \
        xclip \
        go \
        python-pip \
        jq \
        rsync \
        keepass \
        dnsutils \
        xdg-utils \
        libu2f-host \
        httpie \
        tree  \
        ttf-font-awesome \
        i3lock \
        slack

xyay    keybase-bin \
        envypn-font \
        siji-git \
        python2-zeroconf \
        spotify \
        zoom \
        wat
    

xpip    yq \
        p7zip

### Termite ###
xpacman termite
mkdir -p ${HOME}/.config/termite
ln -fs ${DOTFILE}/termite/termite.config ${HOME}/.config/termite/config

### ZSH ###
ln -fs ${DOTFILE}/.zshrc ${HOME}/.zshrc
rm -f ${HOME}/.zsh_history && ln -fs ${KB_DOTFILE}/.zsh_history ${HOME}/.zsh_history

xyay oh-my-zsh-git
chsh -s $(which zsh)

rm -rf ${HOME}/.oh-my-zsh
ln -fs /usr/share/oh-my-zsh/ ${HOME}/.oh-my-zsh

### i3 ###
fpacman i3-gaps

rm -rf ${HOME}/.config/i3
# rm -rf ${HOME}/.config/i3status
ln -fs ${DOTFILE}/i3 ${HOME}/.config/i3
# ln -fs ${DOTFILE}/i3status ${HOME}/.config/i3status
xpacman polybar
rm -rf ${HOME}/.config/polybar
ln -fs ${DOTFILE}/polybar ${HOME}/.config/polybar

cat > /etc/polkit-1/rules.d/10-jgsqware.rules << POLKIT
polkit.addRule(function(action, subject) {
    polkit.log("action=" + action);
    polkit.log("subject=" + subject);
    if (action.id == "org.freedesktop.systemd1.manage-units" &&
        (action.lookup("unit") == "openvpn-client@gridscale.service" || action.lookup("unit") == "openvpn-client@vultr.service")&&
        subject.user == "jgsqware") {
        return polkit.Result.YES;
    }
});
POLKIT


### tmux ###

xpacman tmux

rm -rf ${HOME}/.tmux.conf
ln -fs ${DOTFILE}/.tmux.conf ${HOME}/.tmux.conf
TPMDIR=${HOME}/.tmux/plugins/tpm
if [[ ! -d ${TPMDIR} ]]; then
    git clone https://github.com/tmux-plugins/tpm ${TPMDIR}
else
    (
        cd ${TPMDIR}
        git pull -r
    )
fi

### NeoVim ###

xpacman neovim \
        python-neovim 
xyay universal-ctags-git

curl -fLo ${HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -fs ${DOTFILE}/.vimrc ${HOME}/.vimrc
ln -fs ${HOME}/.local/share/nvim/ ${HOME}/.config/nvim
ln -fs ${DOTFILE}/.vimrc ${HOME}/.config/nvim/init.vim
mkdir -p ${HOME}/.config/nvim/colors
# ln -fs ${DOTFILE}/nvim/colors/codedark.vim ${HOME}/.config/nvim/colors/codedark.vim
ln -fs ${DOTFILE}/nvim/colors/nord.vim ${HOME}/.config/nvim/colors/nord.vim

nvim --headless +PlugInstall +qa
nvim --headless +GoInstallBinaries +qa
${HOME}/.config/nvim/plugged/youcompleteme/install.py --go-completer

### AWS cli ###

xpip awscli
mkdir -p ~/.aws
ln -fs ${KB_DOTFILE}/aws.config ~/.aws/config
ln -fs ${KB_DOTFILE}/aws.credentials ~/.aws/credentials

### Docker ###

xpacman docker \
        docker-compose

sudo systemctl enable docker
sudo systemctl start docker
sudo gpasswd -a `whoami` docker

### Kubernetes ###

xyay    kubernetes-helm-bin \
        kubectl \
        kind-bin \
        kubectx # \
        # telepresence # currently borked installation

### xbindkey ###
xpacman xbindkeys
ln -fs ${DOTFILE}/.xbindkeysrc ${HOME}/.xbindkeysrc

### vs code ###
LINE='*               hard    nofile             10000'
grep "${LINE}" -q /etc/security/limits.conf || echo "${LINE}" | sudo tee -a /etc/security/limits.conf
xyay code

code --install-extension ahebrank.yaml2json
code --install-extension arcticicestudio.nord-visual-studio-code
code --install-extension bierner.color-info
code --install-extension bungcip.better-toml
code --install-extension christian-kohler.path-intellisense
code --install-extension ckolkman.vscode-postgres
code --install-extension codezombiech.gitignore
code --install-extension CoenraadS.bracket-pair-colorizer-2
code --install-extension dawhite.mustache
code --install-extension dbaeumer.vscode-eslint
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension emmanuelbeziat.vscode-great-icons
code --install-extension eriklynd.json-tools
code --install-extension esbenp.prettier-vscode
code --install-extension formulahendry.auto-rename-tag
code --install-extension foxhoundn.synthax
code --install-extension GitHub.vscode-pull-request-github
code --install-extension ipedrazas.kubernetes-snippets
code --install-extension lihui.vs-color-picker
code --install-extension marcostazi.VS-code-vagrantfile
code --install-extension mauve.terraform
code --install-extension michelemelluso.gitignore
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-python.python
code --install-extension ms-vscode.Go
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension octref.vetur
code --install-extension OfHumanBondage.react-proptypes-intellisense
code --install-extension PKief.material-icon-theme
code --install-extension pnp.polacode
code --install-extension redhat.vscode-yaml
code --install-extension TCL.reactreduxcoursesnippets
code --install-extension timonwong.shellcheck
code --install-extension Tyriar.sort-lines
code --install-extension wmontalvo.vsc-jsonsnippets

# ### VirtualBox ###
# xpacman virtualbox virtualbox-host-dkms

# sudo gpasswd -a "$(whoami)" vboxusers

### OpenVPN ##
xpacman openvpn
sudo cp "${KB_DOTFILE}/update-resolv-conf.sh /etc/openvpn/update-resolv-conf.sh"
chmod +x /etc/openvpn/update-resolv-conf.sh
sudo cp /home/jgsqware/.config/kb_dotfile/gridscale.ovpn /etc/openvpn/client/gridscale.conf
sudo cp /home/jgsqware/.config/kb_dotfile/vultr.ovpn /etc/openvpn/client/vultr.conf

### Giant Swarm ##
gi gsctl
gi opsctl
ln -fs "${KB_DOTFILE}/gsctl" "${HOME}/.config/gsctl"
