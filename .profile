
export EDITOR=mcedit

export GUI_TERMINALS='lilyterm -e:lxterminal -e:terminal:gnome-terminal:terminator:urxvt:xterm -fullscreen'
export GUI_EDITORS='medit:adie:gedit:kate:scite'
export GUI_FILEMANAGERS='stuurman:pcmanfm:thunar:PathFinder:nautilus:worker'
export GUI_CALCULATORS='galculator:calculator'

__PROFILE_INCLUDED=1

# if running bash, include .bashrc
if [[ -z "$__BASHRC_INCLUDED" ]] ; then
	if [[ -n "$BASH_VERSION" ]] ; then
		if [[ -f "$HOME/.bashrc" ]] ; then
			. "$HOME/.bashrc"
		fi
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

#if [ -d "$HOME/.gem/ruby/2.0.0/bin" ] ; then
#    PATH="$HOME/.gem/ruby/2.0.0/bin:$PATH"
#fi

PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting

if which less &>/dev/null ; then
	export MANPAGER=less
	export PAGER=less
fi
