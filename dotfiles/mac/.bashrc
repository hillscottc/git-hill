echo Loading ~/.bashrc
export CLICOLOR=1

# export LSCOLORS=GxFxCxDxBxegedabagaced
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'


# set -o notify         # Don't wait for job termination notification
# set -o ignoreeof      # Don't use ^D to exit
shopt -s nocaseglob     # Use case-insensitive filename globbing
shopt -s cdspell        # ignore typos when cd-ing


# HISTORY
# Append rather than overwrite the history on disk
shopt -s histappend
export HISTCONTROL=erasedups
export HISTSIZE=10000
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'        # Patterns which should be excluded. '&' suppresses dups.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls'   # Ignore the ls command as well

set bell-style visible

# to show all spec characters
set meta-flag On
set input-meta On
set output-meta On
set convert-meta Off

# set for vim
#export vim='mvim -v'
#alias vim="${vim}"
#alias gvim="mvim"
#export EDITOR="${vim} -g --remote-tab-silent"
#export GIT_EDITOR="${vim} -g -f"

#set -o vi
#set -o emacs

# set for sublime
export VISUAL="subl -w"
export SVN_EDITOR="subl -w"

#export PS1="\n\[\e[32;1m\]\h(\[\e[37;1m\]\u\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\w\[\e[32;1m\])\n(\[\[\e[37;1m\]! \!\[\e[32;1m\])-> \[\e[0m\]"
export PS1="\n\[\e[32;1m\](\[\e[37;1m\]\u\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\w\[\e[32;1m\])\n(\[\[\e[37;1m\]! \!\[\e[32;1m\])-> \[\e[0m\]"


## SET the PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$HOME/bin:/opt/subversion/bin:$PATH
export PATH=$HOME/Downloads/Django-1.1.1/django/bin/:$PATH
export PATH=/usr/local/mysql/bin:/Library/instantclient:$PATH
export PATH=/usr/local/heroku/bin:$PATH
export PATH=$HOME/.rvm/bin:$PATH


## init the PYTHONPATH
#export PYTHONPATH=/usr/lib/python2.6/site-packages
export PYTHONPATH=/Library/Python/2.7/site-packages
## add talus stuff to pythonpath
export PYTHONPATH=$PYTHONPATH:~/taluslabs/shared-libs/TalusLabsSSO:~/taluslabs/shared-libs/TalusLabsAuthBackend:~/taluslabs/shared-libs/TalusLabsAuthBackend/taluslabs_auth_backend:~/taluslabs/nigel

## For non-homebrew Python, you need to amend your PYTHONPATH like so:
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages


## VIRTUALENV and virtualenvwrapper settings
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true


# Load my alias file
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

# Load my functions file
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi

# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion





