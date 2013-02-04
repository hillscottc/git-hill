# source the users bashrc if it exists
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi


export PATH=$HOME/bin:/opt/subversion/bin:$PATH


export vim='mvim -v' 
alias vim="${vim}" 
alias gvim="mvim" 
export EDITOR="${vim} -g --remote-tab-silent" 
export GIT_EDITOR="${vim} -g -f" 

#export VISUAL="subl -w"
#export SVN_EDITOR="subl -w"
#export VISUAL=vi
#export SVN_EDITOR=vi

#export  DYLD_LIBRARY_PATH="/Library/instantclient"
#export LC_CTYPE=en_US.UTF-8


# this line should be last in the file
# export PATH="/Users/hills/Downloads/Django-1.1.1/django/bin/:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/Library/instantclient:$PATH"


export PYTHONPATH=$HOME/taluslabs/shared-libs/TalusLabsSSO:$HOME/taluslabs/shared-libs/TalusLabsAuthBackend:$HOME/taluslabs/shared-libs/TalusLabsAuthBackend/taluslabs_auth_backend:usr/lib/python2.6/site-packages:$PYTHONPATH


export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export DASHBOARD_SETTINGS=$HOME/taluslabs/dashboard/settings/shill.py
