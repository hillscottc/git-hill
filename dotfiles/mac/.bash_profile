# source the users bashrc if it exists
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi


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

##
# Your previous /Users/shill/.bash_profile file was backed up as /Users/shill/.bash_profile.macports-saved_2013-03-30_at_21:02:05
##

# MacPorts Installer addition on 2013-03-30_at_21:02:05: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


##
# Your previous /Users/shill/.bash_profile file was backed up as /Users/shill/.bash_profile.macports-saved_2013-03-30_at_21:22:49
##

# MacPorts Installer addition on 2013-03-30_at_21:22:49: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
