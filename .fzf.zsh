# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="$PATH:$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.zsh"

# https://rasukarusan.hatenablog.com/entry/2018/08/14/083000
# Ctrl+F : fzf-cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*'      recent-dirs-max 100
zstyle ':chpwd:*'      recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert botho
function fzf-cdr() {
  target_dir=`cdr -l | fzf | sed 's/^[^ ][^ ]*  *//'`
  target_dir=`echo ${target_dir/\~/$HOME}`
  if [ -n "$target_dir" ]; then
    cd $target_dir
    BUFFER=""
    zle accept-line
  fi
}
zle -N fzf-cdr
bindkey '^F' fzf-cdr

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -uf | sed 1d | fzf -m --reverse | awk '{print $2}')
  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Ctrl+s : cdr
function cdr-refresh() {
  cdr
  BUFFER=""
  zle accept-line
}
zle -N cdr-refresh
bindkey '^S' cdr-refresh
