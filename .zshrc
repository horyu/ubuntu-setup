# anyenv (PATHは.zshenv)
eval "$(anyenv init - zsh --no-rehash)"
# eval "$(anyenv init - zsh)"

# 特殊キー
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5C"  forward-word
bindkey "^[[1;5D"  backward-word
# bindkey "\eOD"  backward-word
# bindkey "\eOC"  forward-word

# 色を使用
autoload -Uz colors; colors
# プロンプトを表示する際に変数を展開
setopt prompt_subst
# プロンプト
function check_last_exit_code() {
  if [[ $? -eq 0 ]]; then
    echo "%{${fg[green]}%}[%d]%{${reset_color}%}"
  else
    echo "%{${fg[red]}%}[%d]%{${reset_color}%}"
  fi
}
PROMPT='$(check_last_exit_code)
'

# 日本語を使用
export LANG=ja_JP.UTF-8

# Ctrl+Dによるログアウトを防ぐ
setopt ignore_eof
# ディレクトリ名だけでcdする
setopt auto_cd
# 補完
autoload -Uz compinit; compinit
# 補完候補を ←↓↑→ でも選択出来るようにする
zstyle ':completion:*:default' menu select=1
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors ''

# ヒストリー系
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# ヒストリーに重複を表示しない
setopt hist_ignore_all_dups
# 古いコマンドと同じものは無視
setopt hist_save_no_dups
# 他のターミナルとヒストリーを共有
setopt share_history

# エイリアス
alias rl='exec $SHELL -l'
alias rmrf='rm -rf'
alias tree='tree -C'
alias grep='grep --color=always'
alias l='ls -F --color=always'
alias la='l -A'
alias ll='l -l'
alias lsa='l -Al'
alias ldot='l -d .?* 2>/dev/null'
alias p='ps auf'
alias v='vim'

alias -g GREP=' | grep '
alias -g WC=' | wc '

alias api="sudo apt install"
alias apc="sudo apt clean"
alias apa="sudo apt autoclean"
alias app="sudo apt purge"
alias apr="sudo apt remove"
alias apar="sudo apt autoremove"
alias apu="sudo apt update"
alias apug="sudo apt upgrade"
alias apud="sudo apt update && sudo apt dist-upgrade"
alias apuu="sudo apt update && sudo apt upgrade"
alias apuuy="sudo apt update && sudo apt upgrade -y"

alias g='git'
alias gs='git status -sb'
alias gsh='git stash'
alias gsh-u='git stash -u'
alias gl='git log'
alias gl-o='git log --oneline'
alias gd='git diff'
alias gd-c='git diff --cached'
alias ga='git add'
alias ga.='git add .'
alias gc='git commit'
alias gc-a='git commit --amend'
alias gc-m='git commit -m'
alias gp='git pull --rebase --autostash'
alias gb='git branch'
alias gb-d='git branch -d'
alias gb-D='git branch -D'
alias gb-m='git branch -m'
alias gsw='git switch'
alias gsw-='git switch -'
alias gsw-c='git switch -c'
alias gr='git restore'

# mkdirとcdを同時実行
function mkcd() {
  if [[ -d $1 ]]; then
    echo "$1 already exists!"
    cd $1
  else
    mkdir -p $1 && cd $1
  fi
}

# Mac風クリア Ctrl+K でバインド
function my-clear() {
  clear && echo -en "\e[3J"
}
zle -N my-clear
bindkey '^K' my-clear

# 無入力Enterでls
function do_enter() {
  if [ -z $BUFFER ]; then
    ls -F --color=always
  fi
  zle accept-line
}
zle -N do_enter
bindkey '^m' do_enter

# 直前のコマンドを実行
function repeat_last_command() {
  zle push-line
  BUFFER=`fc -ln -1` 
  zle accept-line
}
zle -N repeat_last_command
bindkey '^G' repeat_last_command

# .git があるディレクトリへ cd
function cdg() {
  cd "$(git rev-parse --show-toplevel)"
}

# Ctrl+S（画面出力の停止）を禁止
if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

# fzf設定
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 重複PATHの削除
typeset -U path PATH

# zshファイル更新したら自動でコンパイル
function() {for arg; do
  if [ ! -f ${arg}.zwc -o ${arg} -nt ${arg}.zwc ]; then
    zcompile ${arg}
  fi
done} ~/.zshrc ~/.zshenv ~/.fzf.zsh
