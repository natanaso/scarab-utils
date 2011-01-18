if [ -e /opt/ros/cturtle/setup.bash ]; then
    source /opt/ros/cturtle/setup.bash
elif [ -e /opt/ros/cturtle/setup.sh ]; then
    source /opt/ros/cturtle/setup.sh
else
    echo "Problem finding ros setup file"
fi

# List all folders found in $HOME/git & $HOME/svn
PACKAGES=`find $HOME/git $HOME/svn -maxdepth 1 -mindepth 1 | sed 's/$/:/' | tr -d '\n'`
export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:${PACKAGES}
unset PACKAGES
export ROS_PACKAGE_PATH=$HOME/git/bearing-localization-with-rssi:$HOME/git/multimaster-ros-pkg:${ROS_PACKAGE_PATH}
