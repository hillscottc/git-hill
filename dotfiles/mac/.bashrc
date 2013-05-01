
export CLICOLOR=1

# export LSCOLORS=GxFxCxDxBxegedabagaced
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'

#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
 shopt -s nocaseglob
#
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
 shopt -s cdspell

# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
# Make bash append rather than overwrite the history on disk
shopt -s histappend

# Don't put duplicate lines in the history.
export HISTCONTROL=erasedups
export HISTSIZE=10000

#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
 export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

# Aliases
#
# Some people use a different file for aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi
#
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias df='df -h'
alias du='du -h'
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias h=history
#alias cd..="cd .."
alias l="ls -al"
#alias lp="ls -p"
alias c:='cd /cygdrive/c'
alias cdev='cd ~/taluslabs/developers/shill'
alias cdash='cd ~/taluslabs/dashboard'
alias chill='cd ~/git-hill'

#if you don't like the annoying end-of-line beeps:
set bell-style visible

# to show all spec characters
set meta-flag On
set input-meta On
set output-meta On
set convert-meta Off


export vim='mvim -v'
alias vim="${vim}"
alias gvim="mvim"
export EDITOR="${vim} -g --remote-tab-silent"
export GIT_EDITOR="${vim} -g -f"

# set vim mode for bash
set -o vi

#export VISUAL="subl -w"
#export SVN_EDITOR="subl -w"
#export VISUAL=vi
#export SVN_EDITOR=vi

#export PS1="\n\[\e[32;1m\]\h(\[\e[37;1m\]\u\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\w\[\e[32;1m\])\n(\[\[\e[37;1m\]! \!\[\e[32;1m\])-> \[\e[0m\]"
export PS1="\n\[\e[32;1m\](\[\e[37;1m\]\u\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\w\[\e[32;1m\])\n(\[\[\e[37;1m\]! \!\[\e[32;1m\])-> \[\e[0m\]"

export PATH=$HOME/bin:/opt/subversion/bin:$PATH

export  DYLD_LIBRARY_PATH="/Library/instantclient"
export LC_CTYPE=en_US.UTF-8
export PATH=$HOME/Downloads/Django-1.1.1/django/bin/:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/Library/instantclient:$PATH

# turned tis off for heroku
#export PYTHONPATH=$HOME/taluslabs/shared-libs/TalusLabsSSO:$HOME/taluslabs/shared-libs/TalusLabsAuthBackend:$HOME/taluslabs/shared-libs/TalusLabsAuthBackend/taluslabs_auth_backend:usr/lib/python2.6/site-packages:$PYTHONPATH


# For non-homebrew Python, you need to amend your PYTHONPATH like so:
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export DASHBOARD_SETTINGS=$HOME/taluslabs/dashboard/settings/shill.py


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
