export ZSH=/usr/share/oh-my-zsh
ZSH_THEME="miloshadzic"

ZSH_TMUX_AUTOSTART=true
plugins=(git docker docker-compose go tmux aws)
source $ZSH/oh-my-zsh.sh


# Environment Variable
export XDG_CONFIG_HOME="${HOME}/.config"
export DOTFILE="${HOME}/.config/dotfile"
export KB_DOTFILE="${HOME}/.config/kb_dotfile"
export GOPATH="${HOME}/go"

export LESS=' -R '
export EDITOR=nvim
export CDPATH=".:$GOPATH/src/github.com/giantswarm"

# Common
export PATH="$PATH/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${HOME}/.local/bin:${DOTFILE}/bin"
# Go
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
# Python
export PATH=$PATH:$HOME/.cargo/bin
# Ruby
export PATH="$HOME/.rvm/bin:$PATH"


# Aliases
for file in ${KB_DOTFILE}/aliases/**/*(.); do
    source "$file"
done

for file in ${DOTFILE}/aliases/**/*(.); do
    source "$file"
done

# Functions
for file in ${KB_DOTFILE}/functions/**/*(.); do
    source "$file"
done
for file in ${DOTFILE}/functions/**/*(.); do
    source "$file"
done

# Completion
source /usr/share/fzf/key-bindings.zsh 
source /usr/share/fzf/completion.zsh
source <(helm completion zsh)
source  ${DOTFILE}/completions/tmuxinator.zsh
#source  ${DOTFILE}/completions/kubectx.zsh
#source  ${DOTFILE}/completions/kubens.zsh
source <(kubectl completion zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
