# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

USER=`whoami`
HOSTNAME=`hostname`

set_term_title(){
   echo -en "\033]0;$1\a"
}

set_term_title $USER\@$HOSTNAME

PS1="[\w]$ "
export PS1

# User specific aliases and functions

## Define colors
COLOR_RED="\[\e[31;40m\]"
COLOR_GREEN="\[\e[32;40m\]"
COLOR_YELLOW="\[\e[33;40m\]"
COLOR_BLUE="\[\e[34;40m\]"
COLOR_MAGENTA="\[\e[35;40m\]"
COLOR_CYAN="\[\e[36;40m\]"

COLOR_RED_BOLD="\[\e[31;1m\]"
COLOR_GREEN_BOLD="\[\e[32;1m\]"
COLOR_YELLOW_BOLD="\[\e[33;1m\]"
COLOR_BLUE_BOLD="\[\e[34;1m\]"
COLOR_MAGENTA_BOLD="\[\e[35;1m\]"
COLOR_CYAN_BOLD="\[\e[36;1m\]"

COLOR_NONE="\[\e[0m\]"

## Aliases
alias screensaver='tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'
alias top10='ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10'       # top10 processes being used
alias mkdir='mkdir -p -v'
alias ll='ls -lahF --color'     # -F is important for hidden directories such as someone trying to hide files in "..." below "." and ".."
alias ls='ls -F --color'        # -F is important for hidden directories such as someone trying to hide files in "..." below "." and ".."
alias rm='rm -i'                # prompt before every removal
alias cp='cp -iZ'                # prompt before overwrite & keep selinux contexts
alias mv='mv -iZ'		# prompt before overwrite & keep selinux context
alias df='df -Th'		# Print filesystem type and human readable values
alias du='du -h -c'		# Human readable grand total
alias c='clear'                 
alias g='grep --color'           
alias h='history'
alias t='tail -n 50'
alias x='exit'
alias recent='ls -lAt | head'	# Most recent files
alias grep='grep --color'	# Enable grep to color values when found
alias mkdir='mkdir -Z'		# http://danwalsh.livejournal.com/67751.html
alias mknod='mknod -Z'
alias install='install -Z'

## Misc
PROMPT_COMMAND='history -a'	# Avoid history losses when using multiple terminals
export GREP_COLOR='1;32'	# Color value set to green
complete -cf sudo		# Tab complete for sudo
export EDITOR=vim               # Default editor to VIM
export VISUAL=vim               # Useful for ctrl+x ctrl+e : bash hotkey to put current commandline to text-editor

# default bash_history is 500
export HISTSIZE=1000
export HISTFILESIZE=1000
export HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"
export LESS=-X			# Don't clear the screen after exiting a man page.

## set options
set -o noclobber 		# prevent overwriting files with cat
set -o ignoreeof		# stops ctrl+d from logging me out

## shell options
shopt -s hostcomplete		# tab-completion of hostnames after @
shopt -s cdspell		# This will correct minor spelling errors in a cd command.
shopt -s histappend		# Append to history rather than overwrite (avoid histoy loss)
shopt -s checkwinsize		# Check window after each command
shopt -s dotglob		# files beginning with . to be returned in the results of path-name expansion.

## Personal Functions
# lazy man extract - example: ex tarball.tar
ex() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjfv $1        ;;
            *.tar.gz)    tar xzfv $1     ;;
            *.tar.xz)    tar xJfv $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       rar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xfv $1        ;;
            *.tbz2)      tar xjfv $1      ;;
            *.tgz)       tar xzfv $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Sanbox applications - Need policycoreutils-sandbox package installed for -X
sandboxfirefox() {
	sandbox -X -t sandbox_web_t firefox
}


# Find the printer driver (ppd) type being used
printdriver() {
	lpoptions -d $1 | grep -oe "printer-make-and-model='.*'" | cut -f2 -d "=" | sed -r s/\'//g
}

# Corporate ldapsearch for users
ldapfind() {
	ldapsearch -x -h ldap.prefix.example.com -b dc=example,dc=com uid~=$1
}

# Remove an inode via inode number
rminode() {
	find . -inum $1 -exec rm -i {} \;
}

# Get md5sums of all files in current directory.
md5sumdir() {
	find * -type f -exec md5sum {} \; &> md5sum.txt && echo "Success: md5sum.txt written" || echo "Error: md5sum.txt not written"
}

# Record desktop :: ffmpeg hosted via rpmfusion
record_desktop() {	
	echo "Begin recording in:" ; sleep 1 ; echo 3 ; sleep 1 ; echo 2 ; sleep 1 ; echo 1 ; ffmpeg -f x11grab -s wxga -r 25 -i :0.0  -sameq /tmp/out.mpg && echo "Preview with 'mplayer /tmp/out.mpg'"
}

record_xvid() {
	echo "Begin recording in:" ; sleep 1 ; echo 3 ; sleep 1 ; echo 2 ; sleep 1 ; echo 1 ; xvidcap --file /tmp/out.mpeg --fps 25 --cap_geometry 1920x1080+0+0 --rescale 50 --time 200.0 --start_no 0 --continue yes --gui no --auto && echo "Preview with 'mplayer /tmp/out.mpeg'"
}


consoleclock() {
	while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done &
}

findlarge() {
	find . -type f -size +50000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}
