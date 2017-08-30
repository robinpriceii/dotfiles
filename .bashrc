# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#prompt
PS1="[\w]$ "
export PS1


#terminal title
USER=`whoami`
HOSTNAME=`hostname`

set_term_title(){
   echo -en "\033]0;$1\a"
}

set_term_title $USER\@$HOSTNAME


#environment variables
export PROMPT_COMMAND='history -a'	# Avoid history losses when using multiple terminals
export GREP_COLOR='1;32'	# Color value set to green
export EDITOR=vim               # Default editor to VIM
export VISUAL=vim               # Useful for ctrl+x ctrl+e : bash hotkey to put current commandline to text-editor
export LESS=-X			# Don't clear the screen after exiting a man page.

#default bash_history is 500
export HISTSIZE=1000
export HISTFILESIZE=1000
export HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"


#set options
set -o noclobber 		# prevent overwriting files with cat
set -o ignoreeof		# stops ctrl+d from logging me out


#shell options
shopt -s hostcomplete		# tab-completion of hostnames after @
shopt -s cdspell		# This will correct minor spelling errors in a cd command.
shopt -s histappend		# Append to history rather than overwrite (avoid history loss)
shopt -s checkwinsize		# Check window after each command
shopt -s dotglob		# files beginning with . to be returned in the results of path-name expansion.


#misc
complete -cf sudo		# Tab complete for sudo

#functions
if [ -f ~/.bash.d/functions ]; then
	. ~/.bash.d/functions
fi

#aliases
if [ -f ~/.bash.d/aliases ]; then
	. ~/.bash.d/aliases
fi

#colors
if [ -f ~/.bash.d/colors ]; then
        . ~/.bash.d/colors
fi

