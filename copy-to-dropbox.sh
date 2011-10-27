#!/bin/bash
source=~/git-hill
bak=$source-bak
targ=~/Dropbox/${bak##*/}
#echo $source $bak $targ
rm -rf $bak
mkdir $bak
cp -rf $source/* $bak/
find $bak/ -name ".git" -type d -exec rm -rf {} \;
rm -rf $targ
mv -f $bak $targ
ls -al $source
echo COPIED TO ... $source
echo $targ
ls -al $targ
echo COPIED FROM --$source 
echo TO          --$targ
