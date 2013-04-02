# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


export PATH=$HOME/taluslabs:/usr/bin/:/bin:/usr/local/bin:$PATH
export PYTHONPATH=$HOME/.local/lib/python2.7/site-packages:$HOME/taluslabs:$HOME/taluslabs/shared-libs/TalusLabsSSO:$HOME/taluslabs/shared-libs/TalusLabsAuthBackend:$HOME/taluslabs/shared-libs/TalusLabsAuthBackend/taluslabs_auth_backend:usr/lib/python2.6/site-packages:$HOME/taluslabs/developers/shill:$PYTHONPATH

alias subl="/usr/bin/sublime"
export EDITOR="subl -w"


export WORKON_HOME=$HOME/.local
source $HOME/.local/bin/virtualenvwrapper.sh

# http://virtualenvwrapper.readthedocs.org/en/latest/tips.html
# Make pip use the same directory for virtualenvs as virtualenvwrapper
export PIP_VIRTUALENV_BASE=$WORKON_HOME

# Make pip detect an active virtualenv and install to it,
# without having to pass it the -E parameter.
export PIP_RESPECT_VIRTUALENV=true


# turns off the middle mouse button. It's id 8 at work desktop. http://bit.ly/ZUF2El
xinput set-button-map 8 1 0 3

# Use case-insensitive filename globbing
 shopt -s nocaseglob

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# Whenever displaying the prompt, write the previous line to disk
 export PROMPT_COMMAND="history -a"

#if you don't like the annoying end-of-line beeps:
set bell-style visual


# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

echo SETTING PROMPT
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]-(jobs:\j)\n\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# i commented this so because color stopped with WORKON command.
#unset color_prompt force_color_prompt

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

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls aliases
alias l='ls -CF'
alias la="ls -aF"
alias ld="ls -ld"
alias ll="ls -alF"
alias lt='ls -At1 && echo "------Oldest--"'
alias ltr='ls -Art1 && echo "------Newest--"'

# dev environ aliases
alias cdev='cd ~/taluslabs/developers/shill'
alias cdash='cd ~/taluslabs/dashboard'
# trim newlines
alias tn='tr -d "\n"'
# list TODO/FIX lines from the current project
alias todos="ack -n --nogroup '(TODO|FIX(ME)?):'"
#copy output of last command to clipboard
alias cl="fc -e -|pbcopy"
# share history between terminal sessions
alias he="history -a" # export history
alias hi="history -n" # import history
# make executable
alias ax="chmod a+x"
# edit .bash_profile
alias bp="$EDITOR ~/.bash_profile"
# edit keybindings.dict
alias kb="$EDITOR ~/Library/KeyBindings/DefaultKeyBinding.dict"
# reload your bash config
alias src="source ~/.bash_profile"
# Remove git from a project
alias ungit="find . -name '.git' -exec rm -rf {} \;"
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# set keyboard interupt from ^c to ^k
# stty intr \^k


