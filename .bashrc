# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=1000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
export TERM='xterm-256color'
export TERM='linux'
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

#if [ -n "$force_color_prompt" ]; then
#	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
#		color_prompt=yes
#	else
#		color_prompt=
#	fi
#fi

#if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  #PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
#else
#	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	#alias grep='grep --color=auto'
	#alias fgrep='fgrep --color=auto'
	#alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

eval "$(register-python-argcomplete3 wbsrv)"


export PYTHONSTARTUP=$HOME/.pythonrc.py

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

#.bin added to path
if [ -d "$HOME/.bin" ] ; then
	    PATH="$HOME/.bin:$PATH"
fi 
if [ -d "$HOME/.local/bin" ] ; then
	    PATH="$HOME/.local/bin:$PATH"
fi 
if [ -d "$HOME/android-studio/bin" ] ; then
	    PATH="$HOME/android-studio/bin:$PATH"
fi 


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi




# git current branch shown on terminal
parse_git_branch(){
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "



gitpush() {
	if [ -z $1 ]
	then
		echo "Please, specify a good comment for your commit"
	else
		git pull
		git commit -a -m "$*"
		git push
	fi
} 


# git diff with master, show files or difference into file

gmaster() {
	curbranch=`git rev-parse --abbrev-ref HEAD`
	if [ -n "$1" ]
	then
		if [[ $1 == src* ]]
		then
			git diff master..${curbranch} ${1#"src/"}
		else              
			git diff master..${curbranch} $1
		fi                  
	else                  
		git diff --name-status ..master
	fi
}
grolling() {
	curbranch=`git rev-parse --abbrev-ref HEAD`
	if [ -n "$1" ]
	then
		if [[ $1 == src* ]]
		then
			git diff rs..${curbranch} ${1#"src/"}
		else              
			git diff rs..${curbranch} $1
		fi                  
	else                  
		git diff --name-status ..rs
	fi
}
gkylix() {
	curbranch=`git rev-parse --abbrev-ref HEAD`
	if [ -n "$1" ]
	then
		if [[ $1 == src* ]]
		then
			git diff makylix..${curbranch} ${1#"src/"}
		else              
			git diff makylix..${curbranch} $1
		fi                  
	else                  
		git diff --name-status ..makylix
	fi
}


# extract any type of file
function extract {
	if [ -z "$1" ]; then
		# display usage if no parameters given
		echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
		echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
		return 1
	else
		for n in $@
		do
			if [ -f "$n" ] ; then
				case "${n%,}" in
					*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
						tar xvf "$n"       ;;
					*.lzma)      unlzma ./"$n"      ;;
					*.bz2)       bunzip2 ./"$n"     ;;
					*.rar)       unrar x -ad ./"$n" ;;
					*.gz)        gunzip ./"$n"      ;;
					*.zip)       unzip ./"$n"       ;;
					*.z)         uncompress ./"$n"  ;;
					*.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
						7z x ./"$n"        ;;
					*.xz)        unxz ./"$n"        ;;
					*.exe)       cabextract ./"$n"  ;;
					*)
						echo "extract: '$n' - unknown archive method"
						return 1
						;;
				esac
			else
				echo "'$n' - file does not exist"
				return 1
			fi
		done
	fi
}


# show statistic about command usage

function showstats {
	history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}

function gitwbranch {
  for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r
}

function gitclean {
    git remote prune origin
    git remote show origin
    echo "GIT informations for origin now pruned"
}

pyclean () {
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
}

clint() {
  git status --porcelain -uno | cut -d '/' -f 2- | grep '.py' | grep -v 'Braccio' | xargs -r python3.9 -m pylint
} 


###-tns-completion-start-###
if [ -f /home/cyan/.tnsrc ]; then 
    source /home/cyan/.tnsrc 
fi
###-tns-completion-end-###

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


kworld() {
  echo "> lb"
  wbsrv -c u -g lb
  for server in kelad jkapid kcmd kasd nebd kmobiled
  do
    if [ -z "$1" ];
    then
      wbsrv -c s -g $server &
    else
      echo "> $server"
      wbsrv -c s -g $server
    fi
  done
}
