# Luke's config for the Zoomer Shell

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
export LC_ALL="en_US.UTF-8"

PROMPT="%{%B%}%(?.%{$fg[grey]%}◆.%{$fg[red]%}✖ %?)%{$fg[blue]%} %1~ %(?.%{$fg[grey]%}❯%{$fg[blue]%}❯%{$fg[white]%}❯.%{$fg[red]%}❯❯❯) %{%f%b%}"
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

#bash-like reverse i-search
#bindkey '^R' history-incremental-pattern-search-backward

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

#Same as Luke does with lf but with ranger
rangercd (){
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'rangercd\n'

bindkey -s '^a' 'bc -l\n'

bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


#Fuzzy finder integration
source $HOME/.local/src/fzf/shell/key-bindings.zsh

#AUTOSUGGEST CONFIG
bindkey '^ ' autosuggest-accept
bindkey '^<Tab>' autosuggest-accept
bindkey '^x' autosuggest-execute
zmodload  zsh/zpty #needed for tab completion autosuggest
ZSH_AUTOSUGGEST_USE_ASYNC=1 #can be set to anything, as long as it's set it will work asynchronously
#ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20 #Might be useful for large buffers, but async might be enough
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion) # completion strategy, possible values: history, completion, match_prev_cmd or a combination of those

ZLE_PROMPT_INDENT=0
source $HOME/.local/src/zsh-autosuggestions/zsh-autosuggestions.zsh
# increment/decriment via Ctrl+a, Ctrl+x
source $HOME/.local/src/vi-increment/vi-increment.zsh
# Load syntax highlighting; should be last.
source $HOME/.local/src/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
