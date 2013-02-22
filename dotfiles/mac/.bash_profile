# source the users bashrc if it exists
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

echo in ~/.bash_profile


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
#export PATH="/Users/hills/Downloads/Django-1.1.1/django/bin/:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/Library/instantclient:$PATH"


export PYTHONPATH=$HOME/taluslabs/shared-libs/TalusLabsSSO:$HOME/taluslabs/shared-libs/TalusLabsAuthBackend:$HOME/taluslabs/shared-libs/TalusLabsAuthBackend/taluslabs_auth_backend:usr/lib/python2.6/site-packages:$PYTHONPATH


export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export DASHBOARD_SETTINGS=$HOME/taluslabs/dashboard/settings/shill.py


# sshfs 10.10.4.76:/home/shill ~/mounts/workdesk -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=workdesk,noappledouble




# Remote Mount (sshfs)
# creates mount folder and mounts the remote filesystem    http://bit.ly/VW1HQ0
rmount() {
    local host folder mname
    host="${1%%:*}:"
    [[ ${1%:} == ${host%%:*} ]] && folder='' || folder=${1##*:}
    if [[ $2 ]]; then
        mname=$2
    else
        mname=${folder##*/}
        [[ "$mname" == "" ]] && mname=${host%%:*}
    fi
    if [[ $(grep -i "host ${host%%:*}" ~/.ssh/config) != '' ]]; then
        # mkdir -p ~/mounts/$mname > /dev/null
        # sshfs $host$folder ~/mounts/$mname -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=$mname,noappledouble && echo "mounted ~/mounts/$mname"
        echo sshfs $host$folder ~/mounts/$mname -oauto_cache,reconnect,defer_permissions,negative_vncache,volname=$mname,noappledouble
        # 10.10.4.76:/home/shill ~/mounts/workdesk
    else
        echo "No entry found for ${host%%:*}"
        return 1
    fi
}

# Remote Umount, unmounts
rumount() {
    if [[ $1 == "-a" ]]; then
        ls -1 ~/mounts/|while read dir
        do
            [[ $(mount|grep "mounts/$dir") ]] && umount ~/mounts/$dir
            # Risky?
            #[[ $(ls ~/mounts/$dir) ]] || rm -rf ~/mounts/$dir
        done
    else
        [[ $(mount|grep "mounts/$1") ]] && umount ~/mounts/$1
        # Risky?
        # [[ $(ls ~/mounts/$1) ]] || rm -rf ~/mounts/$1
    fi
}
