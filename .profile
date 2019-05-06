_add_path()
{
	if [ -d "$1" ] ; then
		PATH="$1:$PATH"
	fi
	export PATH
}

_add_path /usr/games
_add_path "$HOME/.bin"
#_add_path "$HOME/../Моё/Программирование/tt"
_add_path "$HOME/.rvm/bin"

export PATH HOME TERM

###########################################################################

_select_app()
{
	if which "$2" >/dev/null 2>/dev/null ; then
		export "$1"="$2"
	fi
}

_select_app EDITOR   mcedit
_select_app MANPAGER less
_select_app PAGER    less

###########################################################################

export GUI_TERMINALS='lilyterm -e:lxterminal -e:terminal:gnome-terminal:terminator:urxvt:xterm -fullscreen'
export GUI_EDITORS='medit:adie:gedit:kate:scite'
export GUI_FILEMANAGERS='stuurman:pcmanfm:thunar:PathFinder:nautilus:worker'
export GUI_CALCULATORS='galculator:calculator'

###########################################################################

__PROFILE_INCLUDED=1

# if running bash, include .bashrc
if [[ -z "$__BASHRC_INCLUDED" ]] ; then
	if [[ -n "$BASH_VERSION" ]] ; then
		if [[ -f "$HOME/.bashrc" ]] ; then
			. "$HOME/.bashrc"
		fi
	fi
fi

if [[ -n "$KSH_VERSION" ]] ; then
	if [[ -f "$HOME/.kshrc" ]] ; then
		export ENV="$HOME/.kshrc"
	elif [[ -f /etc/ksh.kshrc ]] ; then
		export ENV=/etc/ksh.kshrc
	fi
fi
