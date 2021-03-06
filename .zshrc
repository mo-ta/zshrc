#=======================  zshrc  =================================
autoload -U compinit
compinit

# 色の読み込み
autoload -Uz colors
colors

#ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

############  path  ###################{{{
export LD_LIBRARY_PATH=/usr/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export PYTHONPATH=~/Works/RL/python-codec/src:~/.local/lib/python2.7/site-packages:$PYTHONPATH
export PATH=~/bin:$PATH
export CDPATH=$HOME:$HOME/work:$HOME/work/GIT
export XDG_CONFIG_HOME=$HOME/.config
typeset -U path cdpath fpath manpath
#}}}

############  precmd hook ##############{{{
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
	    if [ ${PWD} = ${HOME} ]; then
		ls -Fv --color=auto --group-directories-first
            else
		ls -FAv --color=auto --group-directories-first
	    fi
	fi
        pre=${PWD}
    }
    ;;

esac
#}}}

############  history  #############{{{
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
setopt hist_ignore_all_dups # ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_reduce_blanks # 余分な空白は詰めて記録

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
 
#余分なヒストリは追加しない
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    # 以下の条件をすべて満たすものだけをヒストリに追加する
    [[ ${#line} -ge 5
        && ${cmd} != (l|l[sal])
        && ${cmd} != (cd)
        && ${cmd} != (man)
        && ${cmd} != (rm[d])
        && ${cmd} != (reboot)
        && ${cmd} != (shutdown)
    ]]
}
#}}}

############  alias  #############{{{
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

#}}}

############  extended glob  #############{{{
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
  "Do"    "~/Documents"
  "Dl"    "~/Downloads"
  "De"    "~/Desktop"
  "Dw"    "~/work"
  "Dg"    "~/work/GIT"
  ":a"     '(:a)'
  ':A'     '(:A)'
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[:-_a-zA-Z0-9]#}
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
#}}}

############  zaw  #############{{{
#http://d.hatena.ne.jp/rubikitch/20071104/1194183191
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 500 # cdrの履歴を保存する個数
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both
source ~/.zaw/zaw.zsh
zstyle ':filter-select:highlight' selected fg=black,bg=white,standout
zstyle ':filter-select' case-insensitive yes

bindkey '^@' zaw-cdr
bindkey '^R' zaw-history
bindkey '^X^F' zaw-git-files
bindkey '^X^B' zaw-git-branches
bindkey '^X^P' zaw-process
bindkey '^A' zaw-tmux
#}}}

############  prompt  ###############{{{
vistate=""
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    viins) vistate="|I"   ;;
    vicmd) vistate="|${bg[blue]}R${bg[default]}" ;;
    main)  vistate="  "   ;;
  esac
  PROMPT="[%.$vistate]%# "
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
#bindkey -M viins 'jj' vi-cmd-mode

PROMPT2="%_%% "
SPROMPT="%r is correct? [n,y,a,e]: "

#}}}

############  other option  #############{{{
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt correct
setopt list_packed
setopt nolistbeep
setopt complete_aliases
setopt noautoremoveslash #パス補完時にスラッシュをつける
#ドットファイルにマッチさせるために先頭に'.'を付ける必要がなくなる。
setopt globdots
#}}}

#############  keyバインドの変更  ##############{{{
bindkey -v
##keyバインドの変更(xscape 必要)
##CapsLock -> Ctrl
##Hennkan  -> Esc
##colon    -> 押している間Ctrl
##         -> 何も押さずに離すとcolon
##Space    -> 押している間Shift
##         -> 何も押さずに離すとspace
##hiragana -> Enter
##alt_r    -> XF86DOS (キーボード・ショートカット用)
##code space(65) capslock(66) henkan(100) colon(48)
##     Hiragana(101) Alt-R(108)
pid_xscape=`pidof xcape`
if [ -z ${pid_xscape} ]; then #プロセスみて多重起動防止
#---------------------.Xmodmapに移した(xcape以外)----------
        #----mod-key の無効化-----
#        xmodmap -e 'remove Lock    = Caps_Lock'
#        xmodmap -e 'remove Control = Control_L'
#        xmodmap -e 'remove Shift   = Shift_L'  
#        xmodmap -e 'remove mod1    = Alt_R' 
#        
#        #----key変更--------
#        xmodmap -e 'keycode 66  = Control_L' #capslock =>ctrl(L)
#        xmodmap -e 'keycode 100 = Escape'    #henkan   =>esc
#	 xmodmap -e 'keycode 101 = Return'
#	 xmodmap -e 'keycode 108 = XF86DOS'
#
#        #----keycodeの保存----------
#        xmodmap -e 'keycode 255 = space'  #space    
#        xmodmap -e 'keycode 254 = colon asterisk'  #colon
#
#        #----key-on時の動作---------
#        xmodmap -e 'keycode 65 = Shift_L'     #space    =>one-key mod shift(L)
#        xmodmap -e 'keycode 48 = Control_L'   #colon=>one-key mod ctrl(L)
#
#
#        #----mod-keyの最有効化-----
#        xmodmap -e 'add Control = Control_L'
#        xmodmap -e 'add Shift   = Shift_L'

#        #----key-off時の動作-----
	xcape -e   '#65=space;#48=colon'
fi
#}}}
