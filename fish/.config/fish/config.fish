 ########################################
# Environment variables
########################################
# fzf
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# sdkman
set -x SDKMAN_DIR "$HOME/.sdkman"

# history
set -x HISTFILE "$HOME/.zsh_history"
set -x HISTSIZE "20000"
set -x SAVEHIST "20000"

# android
set -x ANDROID_HOME "$HOME/Android/Sdk"
set -x ANDROID_SDK_ROOT "$HOME/Android/Sdk"

# editor
set -x EDITOR "nvim"


########################################
# Path
########################################
set -gx PATH $HOME/.local/bin $PATH
[ -d $HOME/.yarn/bin ] && set -gx PATH $HOME/.yarn/bin $PATH
[ -d $HOME/.poetry/bin ] && set -gx PATH $HOME/.poetry/bin $PATH
[ -d $HOME/.pyenv/bin ] && set -gx PATH $HOME/.pyenv/bin $PATH
[ -d $HOME/tools/flutter/bin ] && set -gx PATH $HOME/tools/flutter/bin $PATH
[ -d $HOME/.cargo/bin ] && set -gx PATH $HOME/.cargo/bin $PATH
if test -d "$HOME/Android/Sdk"
    set -gx PATH $HOME/Android/Sdk/emulator $PATH
    set -gx PATH $HOME/Android/Sdk/platform-tools $PATH
    set -gx PATH $HOME/Android/Sdk/tools $PATH
    set -gx PATH $HOME/Android/Sdk/tools/bin $PATH
end


########################################
# Aliases
########################################
[ (command -v exa) ] && alias ls "exa" || alias ls "ls --color=always"
alias ll "ls -lh"
alias la "ls -lha"
abbr tna "tmux new -A -s"
abbr gdh "git diff HEAD"
[ (command -v nvim) ] && abbr vim "nvim"
[ (command -v bat) ] && alias cat "bat --theme=TwoDark"
abbr nr "npm run"


########################################
# Functions
########################################
function mcd --argument-names directory
    mkdir -p "$directory" && cd "$directory"
end

function dockstop --argument-names 'prefix'
    if test -n "$prefix"
        echo "Stopping containers starting with '[$prefix]'"
        docker ps --format '{{.Names}}' | grep "$prefix" | awk '{print $prefix}' | xargs -I {} docker stop {}
    else
        echo "Stopping all containers"
        docker stop (docker ps -q)
    end
end


########################################
# Colors
########################################
set -U fish_color_autosuggestion      brblack
set -U fish_color_cancel              -r
set -U fish_color_command             brgreen
set -U fish_color_comment             brmagenta
set -U fish_color_cwd                 green
set -U fish_color_cwd_root            red
set -U fish_color_end                 brmagenta
set -U fish_color_error               brred
set -U fish_color_escape              brcyan
set -U fish_color_history_current     --bold
set -U fish_color_host                normal
set -U fish_color_match               --background=brblue
set -U fish_color_normal              normal
set -U fish_color_operator            cyan
set -U fish_color_param               brblue
set -U fish_color_quote               yellow
set -U fish_color_redirection         bryellow
set -U fish_color_search_match        'bryellow' '--background=brblack'
set -U fish_color_selection           'white' '--bold' '--background=brblack'
set -U fish_color_status              red
set -U fish_color_user                brgreen
set -U fish_color_valid_path          --underline
set -U fish_pager_color_completion    normal
set -U fish_pager_color_description   yellow
set -U fish_pager_color_prefix        'white' '--bold' '--underline'
set -U fish_pager_color_progress      'brwhite' '--background=cyan'

########################################
# Load stuff
########################################
# direnv
[ (command -v direnv) ] && eval (direnv hook fish)

# thefuck
[ (command -v thefuck) ] && thefuck --alias | source

# vi keybindings
fish_vi_key_bindings

