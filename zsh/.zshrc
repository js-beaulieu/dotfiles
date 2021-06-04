#########################################
# Environment variables
########################################
# fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"

# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE="20000"
export SAVEHIST="20000"

# android
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

# editor
export EDITOR="nvim"

# bspwm fix for java apps
export _JAVA_AWT_WM_NONREPARENTING=1

# auto use nvm
export NVM_AUTO_USE=true

########################################
# Path
########################################
typeset -U path
path=($HOME/.bin $HOME/.local/bin $path)
[ -d $PYENV_ROOT/bin ] && path=($PYENV_ROOT/bin $path)
[ -d $HOME/.yarn/bin ] && path=($HOME/.yarn/bin $path)
[ -d $HOME/.poetry/bin ] && path=($HOME/.poetry/bin $path)
[ -d $HOME/tools/flutter/bin ] && path=($HOME/tools/flutter/bin $path)
[ -d $HOME/.cargo/bin ] && path=($HOME/.cargo/bin $path)
if [ -d "$HOME/Android/Sdk" ]; then
    path=(PATH $HOME/Android/Sdk/emulator $path)
    path=(PATH $HOME/Android/Sdk/platform-tools $path)
    path=(PATH $HOME/Android/Sdk/tools $path)
    path=(PATH $HOME/Android/Sdk/tools/bin $path)
fi
export PATH

########################################
# Misc
########################################
# shell
setopt auto_cd

# Load ssh keys
privatekeys=()
for publickey in ${HOME}/.ssh/*.pub; do
    privatekeys+=(`basename ${publickey%.*}`)
done
zstyle :omz:plugins:ssh-agent identities $privatekeys

# pyenv
if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# direnv
eval "$(direnv hook zsh)"

# Load antibody
autoload -Uz compinit
compinit -i
[ -f $HOME/.zsh_plugins.sh ] && . $HOME/.zsh_plugins.sh

# SdkMan
[[ -s "/home/jsbeaulieu/.sdkman/bin/sdkman-init.sh" ]] && source "/home/jsbeaulieu/.sdkman/bin/sdkman-init.sh"

# tabtab source for packages
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

########################################
# Aliases
########################################
[ $(command -v exa) ] && alias ls="exa" || alias ls="ls --color=always"
[ $(command -v nvim) ] && alias vim="nvim"
[ $(command -v bat) ] && alias cat="bat --theme=TwoDark"
alias ll="ls -lh"
alias la="ls -lha"
alias tna="tmux new -A -s"
alias gdh="git diff HEAD"
alias nr="npm run"
alias zshr="antibody bundle < ~/.zsh_plugins > $HOME/.zsh_plugins.sh && echo 'static plugin file generated'"

function gcof() {
    git checkout $(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ | head -20 | fzf)
}

function mcd() {
    mkdir -p $@ && cd ${@:$#}
}

function dockstop() {
    if [ -z "$1" ]; then
        echo "Stopping all containers"
        docker stop $(docker ps -q)
    else
        echo "Stopping containers starting with '[$1]'"
        docker ps --format '{{.Names}}' | grep "$1" | awk '{print $1}' | xargs -I {} docker stop {}
    fi
}

