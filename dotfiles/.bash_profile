export PATH=/opt/subversion/bin/:/Users/hills/Scripts:/usr/local/mysql/bin:$PATH

export EDITOR=vi
#export VISUAL="subl -w"
#export SVN_EDITOR="subl -w"
export VISUAL=vi
export SVN_EDITOR=vi


export PS1="\n\[\e[32;1m\](\[\e[37;1m\]\u\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\w\[\e[32;1m\])\n(\[\[\e[37;1m\]! \!\[\e[32;1m\])-> \[\e[0m\]"

# this in .bashrc now
#shopt -s histappend
#export HISTCONTROL=erasedups
#export HISTSIZE=10000

# source the users bashrc if it exists
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi





