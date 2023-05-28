
# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

#####################################################################

# Force .profile to be processed

__BASHRC_INCLUDED=1

if [[ -z "$__PROFILE_INCLUDED" ]] ; then
	if [[ -f ~/.profile ]] ; then
		. ~/.profile
	fi
fi

#####################################################################

# Include system-wide defaults

if [[ -n "$BASH_VERSION" ]] ; then
	if [[ -f /etc/bash.bashrc ]] ; then
		. /etc/bash.bashrc
	fi
	# enable programmable completion features, if it not yet enabled by /etc/bash.bashrc
	if [[ -z "$BASH_COMPLETION" && -f /etc/bash_completion ]] ; then
		. /etc/bash_completion
	fi
fi

if [[ -n "$KSH_VERSION" ]] ; then
	if [[ -f /etc/ksh.kshrc ]] ; then
		. /etc/ksh.kshrc
	fi
fi

#####################################################################

# Set up rvm environment

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

#####################################################################

# Set up pyenv environment

if test -d "$HOME/.pyenv" ; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init --path)"
	eval "$(pyenv init -)"
fi

#####################################################################

# Useful functions

# Display unique lines
function dedup {
	awk '! x[$0]++' $@
}

# Enter directory and display the listing
c(){ cd "$@" && ls ; }

# Create directory and enter it
m(){ mkdir -p "$1" && cd "$1"; }

# Create file with full path
mkdir-touch(){ mkdir -p "`dirname "$1"`" && touch "$1" ; }

# Highligh pattern
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

# History Settings

if [[ -n "$BASH_VERSION" ]] ; then
	export HISTFILE=~/.bash_history
	export HISTCONTROL=ignoreboth:erasedups
	export HISTIGNORE=mc:ls:l:ll:la:df:du:bc:cd:su:top:pstree:bg:fg:su
	export HISTSIZE=15000
	export HISTFILESIZE=$HISTSIZE
	# append to the history file, don't overwrite it
	shopt -s histappend
else
	export HISTFILE=~/.sh_history
	export HISTSIZE=15000
fi

function history_cleanup {
	printf "Записей в истории было: %s\n" "`history | wc -l`"
	local HISTFILE_SRC="${HISTFILE}"
	local HISTFILE_TMP="${HISTFILE}_dedup"
	if [[ -f "$HISTFILE_SRC" ]] ; then
		cp "$HISTFILE_SRC" "$HISTFILE_SRC.backup" && \
			(tac < $HISTFILE_SRC | dedup | tac > "$HISTFILE_TMP") && test -s "$HISTFILE_TMP" && \
			mv "$HISTFILE_TMP" "$HISTFILE_SRC"
		history -c
		history -r
	fi
	printf "Стало: %s\n" "`history | wc -l`"
}

#####################################################################

if [[ -n "$BASH_VERSION" ]] ; then
	# check the window size after each command and, if necessary,
	# update the values of LINES and COLUMNS.
	shopt -s checkwinsize
fi

#####################################################################

# make less more friendly for non-text input files, see lesspipe(1)
[ -x "`which lesspipe.sh 2>/dev/null`" ] && eval "$(SHELL=/bin/sh lesspipe.sh)"

#####################################################################

# Коды для установки цвета фона.

if [[ -z "$__COLORS_EXPORTED" ]] ; then

COLORS='
BLACK=0;30
BLUE=0;34
GREEN=0;32
CYAN=0;36
RED=0;31
PURPLE=0;35
BROWN=0;33
LIGHTGRAY=0;37
DARKGRAY=1;30
LIGHTBLUE=1;34
LIGHTGREEN=1;32
LIGHTCYAN=1;36
LIGHTRED=1;31
LIGHTPURPLE=1;35
YELLOW=1;33
WHITE=1;37
NOCOLOR=0'

eval "$(echo "$COLORS" | grep '.' | sed -e 's/^/COLOR_/' -e 's/=\(.*\)$/='\''\1'\''/')"
eval "$(echo "$COLORS" | grep '.' | sed -e 's/^/export PS_COLOR_/' -e 's/=\(.*\)$/='\''\\[\\e[\1m\\]'\''/')"
eval "$(echo "$COLORS" | grep '.' | sed -e 's/^/export CODE_COLOR_/' -e 's/=\(.*\)$/='\''\\033[\1m'\''/')"

unset COLORS

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

# make grep 3.8 happy
function egrep { grep -E "$@" ; }
function fgrep { grep -F "$@" ; }

# enable color support of ls and also add handy aliases
if [[ -x "`which dircolors 2>/dev/null`" ]] ; then
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

alias sgrep="grep \
  --color=auto \
  -r -n \
  --exclude-dir=.svn \
  --exclude-dir=.git \
  --exclude-dir=.deps \
  --exclude-dir=build-aux \
  --exclude-dir=m4 \
  --exclude-dir=*-obj \
  --exclude='*.[oa]' \
  --exclude='*.so' \
  --exclude='*.xz' \
  --exclude='*~' \
  --exclude-dir=autom4te.cache \
  --exclude=aclocal.m4 \
  --exclude=config.sub \
  --exclude=ltmain.sh \
  --exclude=.intltool-merge-cache"

alias sgrep-fixme="sgrep \
  --exclude=configure \
  --exclude=libtool \
  --exclude=depcomp \
  --exclude=config.status \
  --exclude=Makefile.in \
  -E 'FIXME|TODO|XXX'"


alias mnt="mount | cut -d' ' -f 1,3,5,6 | grc column -t"

if [[ -x "`which yt-dlp 2>/dev/null`" ]] ; then
	alias youtube-dl=yt-dlp
fi

alias yt-dl-720-s="youtube-dl -o '%(title)s [%(id)s].%(ext)s' -f 'best[height<=720]'"
alias yt-dl-720="youtube-dl -o '%(title)s [%(id)s].%(ext)s' -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'"
alias yt-dl-1080="youtube-dl -o '%(title)s [%(id)s].%(ext)s' -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]'"
alias yt-dl-720-no-id="youtube-dl -o '%(title)s.%(ext)s' -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'"
alias yt-dl-1080-no-id="youtube-dl -o '%(title)s.%(ext)s' -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]'"

alias fixterm='stty sane; tput rs1; echo -e "\033c"'

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

bind '"\ey"':"\" yt-dl-720 \""

#####################################################################

# Color settings for various tools

#export GREP_OPTIONS='--color=auto'
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

list_signals() {
	# Writing sed 's/something/\n/' is not portable.
	# The new line character should be escaped with the backward slash.
	local nl='
'
	kill -l | sed -e 's|) |:|g' -e 's|[[:space:]][[:space:]]*|\'"$nl"'|g' -e 's|SIG||g' | egrep '[0-9]' | sed 's|:|\'"$nl"'|'
}

# Формируем массив с соответствиями кодов возврата и сигналов.
# Коды возврата при завершении программы сигналом равны 128 + номер сигнала. Номера сигналов берём из kill -l.
declare -A SIGCODES
while read code ; do
	read value
	code=`expr 128 + $code`
	SIGCODES[${code}]="[${value}]"
done < <( list_signals )

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
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|screen*)
		PROMPT_COMMAND='_EXIT_CODE=`format_exit_code $?` ; echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}:${_EXIT_CODE}:${_LAST_BASH_COMMAND}\007"'
		#export PROMPT_COMMAND
		trap debug_trap DEBUG
	;;
	*)
		PROMPT_COMMAND='format_exit_code $? > /dev/null'
	;;
esac

