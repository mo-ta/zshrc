export LD_LIBRARY_PATH=/usr/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export PYTHONPATH=~/Works/RL/python-codec/src:~/.local/lib/python2.7/site-packages:$PYTHONPATH
export PATH=~/bin:$PATH
#kan1
autoload -U compinit
compinit

# 色の読み込み
autoload -Uz colors
colors

case "${TERM}" in
kterm*|xterm)
    precmd() {
	#タイトルへの表示
	if [ ${PWD} = '/' ]; then
		t_t='/'
	elif [ ${PWD} = ${HOME} ]; then
		t_t="~"
        else
		 t_t=${PWD:t}
        fi
        echo -ne "\033]0;${t_t}  (${HOST})\007"

	#カレントディレクトリが変わったらls
	if [ ${PWD} != ${pre:-""} ]; then
		ls -Fv --color=auto --group-directories-first
	fi
        pre=${PWD}
    }
    ;;
esac
#kan3
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

#kan4
bindkey -v

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
 




#kan5
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct
setopt list_packed
setopt nolistbeep

#kan10
setopt complete_aliases #aliasでも補完できるようにする
alias -s rb='ruby'
alias -s py='python'
alias -s dot='xdot 2> /dev/null'
alias -s bat='sh'
alias -s sh='sh'
alias -s zbat='zsh'
alias -s zsh='zsh'
alias -s pdf='atril'
alias -s html='vivaldi 2> /dev/null'

alias h=history

alias lla="ls -AFhvo --color=auto --group-directories-first"
alias la="ls -AFv --color=auto --group-directories-first"
alias l="ls -Fv --color=auto --group-directories-first"
alias ll="ls -Fhvo --color=auto --group-directories-first"

alias gr="grep -nH --color=always" 
alias froot="find / -name $1 2>/dev/null"
alias fhere="find . -name $1 2>/dev/null"

alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -iv"
alias ln="ln -iv"
alias rmd="rm -rfv"

#http://d.hatena.ne.jp/rubikitch/20071104/1194183191

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 500 # cdrの履歴を保存する個数
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

source /home/motoki/work/local/zaw/zaw.zsh
zstyle ':filter-select:highlight' selected fg=black,bg=white,standout
zstyle ':filter-select' case-insensitive yes

bindkey '^@' zaw-cdr
bindkey '^R' zaw-history
bindkey '^X^F' zaw-git-files
bindkey '^X^B' zaw-git-branches
bindkey '^X^P' zaw-process
bindkey '^A' zaw-tmux


setopt extended_glob

typeset -A abbreviations
abbreviations=(
  "Im"    "| more"
  "Ia"    "| awk"
  "Ig"    "| grep"
  "Ieg"   "| egrep"
  "Iag"   "| agrep"
  "Igr"   "| groff -s -p -t -e -Tlatin1 -mandoc"
  "Ip"    "| $PAGER"
  "Ih"    "| head"
  "Ik"    "| keep"
  "It"    "| tail"
  "Is"    "| sort"
  "Iv"    "| ${VISUAL:-${EDITOR}}"
  "Iw"    "| wc"
  "Ix"    "| xargs"
  "DO"    "~/Documents"
  "DL"    "~/Downloads"
  "DE"    "~/Desktop"
  "DW"    "~/work"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}
no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

setopt complete_aliases
setopt noautoremoveslash #パス補完時にスラッシュをつける
#ドットファイルにマッチさせるために先頭に'.'を付ける必要がなくなる。
setopt globdots

#zshプロンプトにモード表示####################################
vistate=""
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd) vistate="|${bg[blue]}R${bg[default]}" ;;
    viins) vistate="|I"   ;;
    main)  vistate="  "   ;;
  esac
  PROMPT="[%.$vistate]%# "
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
bindkey -M viins 'jj' vi-cmd-mode
#kan2
PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "
#export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#ファイル補完候補に色を付ける
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#
#setopt NO_NOMATCH 
setopt hist_ignore_all_dups
alias wide="resize -s ${LINES} `expr \( ${COLUMNS} \* 11 \) \/ 10` > /dev/null"
#プロファイル:wq
#if type zprof > /dev/null 2>&1; then
#  zprof | less
#fi
