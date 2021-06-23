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
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

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

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar) unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip) unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace) unace x ./"$n"      ;;
            *.zpaq)      zpaq x ./"$n"      ;;
            *.arc)       arc e ./"$n"       ;;
            *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                              extract $n.iso && \rm -f $n ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
