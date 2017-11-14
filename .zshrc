export ZSH=/usr/share/oh-my-zsh
ZSH_THEME="miloshadzic"

ZSH_TMUX_AUTOSTART=true
source $ZSH/oh-my-zsh.sh
plugins=(git docker docker-compose go kubectl tmux aws)
# Environment Variable
XDG_CONFIG_HOME="${HOME}/.config"
DOTFILE="${HOME}/.config/dotfile"
GOPATH="${HOME}/go"

# Aliases

for file in ${DOTFILE}/aliases/**/*(.); do
    source "$file"
done

# Functions
for file in ${DOTFILE}/functions/**/*(.); do
    source "$file"
done

# Completion
source /usr/share/fzf/key-bindings.zsh 
source /usr/share/fzf/completion.zsh
