#!/bin/bash

trap exit INT TERM EXIT

MAX_NUM_ARGS=1
if [ $# -gt $MAX_NUM_ARGS ]
then
    echo "Unexpected arguments."
    echo "Usage: sync.sh [clientIP]        or"
    echo "       sync.sh        // Using ips.sh as a source."
    exit 1
fi

#=============================== PACKAGE CODE ================================#
# Copy from one place to the next excluding .svn files, any folder called test
# or scripts, and python byte code
clone () { rsync -azC --inplace --exclude "scripts/" --exclude="test/" --exclude="*.pyc" $1 $2; }

#nothing needs to be packaged right now...

#============================== TRANSFER FILES ===============================#
DIR=$(pwd)/$(dirname $0) # Folder containing this script
if [ -z $1 ]  # If [clientIP] is given, use it instead of ips.sh
then
    source ${DIR}/ips.sh
else
    IP_LIST=$1
fi

# All files in FILES variable should have absolute paths
ROOT=/home/$USER
FILES="$ROOT/git $ROOT/svn $ROOT/.bashrc $ROOT/bwc-ros.sh $ROOT/.screenrc"

USER=$(whoami)

for IP in ${IP_LIST[@]}
do
    echo Pushing files to $IP
    rsync -avz --inplace $FILES $USER@$IP:/home/$USER
    ssh  $USER@$IP "chown -R $USER:mrsl /home/$USER/"
    echo "done!"
done
