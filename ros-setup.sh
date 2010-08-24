source /opt/ros/setup.sh
# List all folders found in $HOME/git & $HOME/svn
PACKAGES=`find $HOME/git $HOME/svn -maxdepth 1 -mindepth 1 | sed 's/$/:/' | tr -d '\n'`
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:${PACKAGES}
unset PACKAGES
