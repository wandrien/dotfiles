
# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

if [[ -f /etc/bash.bashrc ]] ; then
	. /etc/bash.bashrc
fi

#####################################################################

__BASHRC_INCLUDED=1

# include ~/.profile
if [[ -z "$__PROFILE_INCLUDED" ]] ; then
	if [[ -f ~/.profile ]] ; then
		. ~/.profile
	fi
fi

#####################################################################

# history settings
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE=mc:ls:l:ll:la:df:du:bc:cd:su:top:pstree:bg:fg:su
export HISTSIZE=5000
export HISTFILESIZE=$HISTSIZE
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#####################################################################

# make less more friendly for non-text input files, see lesspipe(1)
[ -x "`which lesspipe.sh 2>/dev/null`" ] && eval "$(SHELL=/bin/sh lesspipe.sh)"


# enable programmable completion features, if it not yet enabled by /etc/bash.bashrc
if [[ -z "$BASH_COMPLETION" && -f /etc/bash_completion ]] ; then
	. /etc/bash_completion
fi

#####################################################################

# Коды для установки цвета фона.
COLOR_BLACK='0;30'
COLOR_BLUE='0;34'
COLOR_GREEN='0;32'
COLOR_CYAN='0;36'
COLOR_RED='0;31'
COLOR_PURPLE='0;35'
COLOR_BROWN='0;33'
COLOR_LIGHTGRAY='0;37'
COLOR_DARKGRAY='1;30'
COLOR_LIGHTBLUE='1;34'
COLOR_LIGHTGREEN='1;32'
COLOR_LIGHTCYAN='1;36'
COLOR_LIGHTRED='1;31'
COLOR_LIGHTPURPLE='1;35'
COLOR_YELLOW='1;33'
COLOR_WHITE='1;37'
COLOR_NOCOLOR='0'


# Формируем коды для переключения цвета в двух вариантах: для подстановки в приглашение PS1 и для подстановки в обычный echo.
if [[ -z "$__COLORS_EXPORTED" ]] ; then
	for i in ${!COLOR_*} ; do
		export PS_$i="\[\033[${!i}m\]"
		export CODE_$i="\033[${!i}m"
	done
	__COLORS_EXPORTED=1
fi


# Раскрашиваем приглашение.
PS1="\
$PS_COLOR_YELLOW\
\u@\h\
$PS_COLOR_NOCOLOR\
:\
$PS_COLOR_LIGHTGREEN\
\w\
$PS_COLOR_NOCOLOR\$ \
"

#####################################################################

# Alias definitions.

#if [[ -f ~/.bash_aliases ]] ; then
#	. ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [[ -x `which dircolors` ]] ; then
	eval "`dircolors -b`"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	#alias grep='grep --color=auto'
	#alias fgrep='fgrep --color=auto'
	#alias egrep='egrep --color=auto'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias mp='mplayer'

alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'

alias del='trash-put'

alias s='less -N'

alias xclipoc="xclip -o -selection clipboard"
alias xclipos="xclip -o"
alias xclipic="tee `tty` | xclip -selection clipboard"
alias xclipis="tee `tty` | xclip"

#alias _fm='exec_first_of -e GUI_FILEMANAGERS'
#alias _ed='exec_first_of -e GUI_EDITORS'

alias sgrep="grep -r -n --exclude-dir=.svn --exclude-dir=.git --exclude='*.[oa]' --exclude='*.so'"

#####################################################################

# Usefull functions

# Заходит в каталог и выводит его содержимое
c(){ cd "$@" && ls ; }
# Создаёт каталог и заходит в него
m(){ mkdir -p "$1" && cd "$1"; }

# Подсвечивает паттерн в содержимом файла
function h
{
	local COLORON="`echo -e $CODE_COLOR_YELLOW`"
	local COLOROFF="`echo -e $CODE_COLOR_NOCOLOR`"

	if [[ -z "$1" ]] ; then
		echo "Usage: h 'regex' [file1 file2 ...]" 1>&2;
		return 1
	fi

	REGEX="$1"
	shift

	sed -e "s/${REGEX}/${COLORON}&${COLOROFF}/g" "$@"
}

#####################################################################

# Hotkeys
bind '"\e`"':"\"\C-a\`\C-e\`\""
bind '"\exw"':"\"which \""
bind '"\exf"':"\"file \""
bind '"\exg"':"\"grep \""
bind '"\exs"':"\"sed \""
bind '"\exd"':"\"find \""
bind '"\exl"':"\"less \""
bind '"\exm"':"\"mkdir -p \""

bind '"\e`"':"\"\C-a\`\C-e\`\""
bind '"\ezs"':"\"su - \C-m\""
bind '"\ezd"':"\"sudo \""
bind '"\ezp"':"\"pacman \""
bind '"\ezy"':"\"yaourt \""

bind '"\eq"':"\"\C-aman \C-e\C-m\""
#bind '"\e\C-q"':"\"\C-ainfo \C-e\C-m\""
#bind '"\e-w"':"\"\C-awhich \C-e\C-m\""
#bind '"\e\C-w"':"\"\C-awhereis \C-e\C-m\""

bind '"\ea"':"\"xclipoc | \""
bind '"\es"':"\"xclipos | \""
bind '"\eA"':"\"\C-e | xclipic\C-m\""
bind '"\eS"':"\"\C-e | xclipis\C-m\""

#####################################################################

# Color settings for various tools

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;33'

export LESS='-R'
#export LESS_TERMCAP_mb=$'\E[01;31m'
#export LESS_TERMCAP_md=$'\E[01;31m'
#export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


#####################################################################

# Colorize output with grc

if [[ -f /usr/bin/grc ]] ; then

  alias grca="grc --colour=auto"

  for c in ping traceroute make diff last cvs netstat ifconfig uptime vmstat iostat df mount uname ps route lsmod whereis ; do
    C="`alias ${c} 2>/dev/null`"
    if [[ -z "$C" ]] ; then
        C="${c}"
    fi
    alias ${c}="grca ${C}"
  done

  alias ll="grca ls --color=force -lh"
  alias ccal="grca cal"
fi

#####################################################################

# Формируем массив с соответствиями кодов возврата и сигналов.
# Коды возврата при завершении программы сигналом равны 128 + номер сигнала. Номера сигналов берём из kill -l.
declare -A SIGCODES
while read code ; do
	read value
	code=`expr 128 + $code`
	SIGCODES[${code}]="[${value}]"
done < <( kill -l | sed -e 's|) |:|g' -e 's|\s|\n|g' -e 's|SIG||g' | egrep '[0-9]' | sed 's|:|\n|' )

# Функция формирует выхлоп код + сигнал.
function format_exit_code
{
	echo -n "$1""${SIGCODES[$1]}"
	# Если код возврата != 0, выводим сообщение также и на tty. (Быдлокод, это должно быть уровнем выше.)
	if [[ $1 != 0 ]] ; then
		echo -e "${CODE_COLOR_RED}Status: $1""${SIGCODES[$1]}${CODE_COLOR_NOCOLOR}" > `tty`
	fi
}

# Обработчик trap DEBUG, позволяющий отслеживать выполнение команд.
function debug_trap
{
	case "${BASH_COMMAND}" in
		# Игнорируем команды от mc.
		*"kill -STOP"* | *"pwd"*)
		;;
		# Игнорируем собственные вспомогательные команды.
		*"_BASH_COMMAND"* | *"format_exit_code"*)
		;;
		*)
			# Выводим информацию в заголовок.
			_BASH_COMMAND1=`echo "${BASH_COMMAND}" | sed -e 's|[[:cntrl:]]|…|g' -e 's|\\\\|\\\\\\\\|g' `
			echo -ne "\033]0;${_BASH_COMMAND1}\007"
			_LAST_BASH_COMMAND=${_BASH_COMMAND1}
	esac
}

case "${TERM}" in
	# Работаем с заголовками окон только в соответствующих эмуляторах терминала.
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
		PROMPT_COMMAND='_EXIT_CODE=`format_exit_code $?` ; echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}:${_EXIT_CODE}:${_LAST_BASH_COMMAND}\007"'
		#export PROMPT_COMMAND
		trap debug_trap DEBUG
	;;
	*)
		PROMPT_COMMAND='format_exit_code $? > /dev/null'
	;;
esac

