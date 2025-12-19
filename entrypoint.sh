#!/bin/bash
set -e

# Sourcingg
source /opt/ros/humble/setup.bash
source /home/catkin_ws/install/setup.bash

# sim
echo "Starting sim..."
ros2 launch fastbot_gazebo one_fastbot_room.launch.py &
sleep 20

#  action server
echo "starting action server"
ros2 run fastbot_waypoints fastbot_action_server &
sleep 5

# testtttsss
echo "TESTTTS"
cd /home/catkin_ws
colcon test --packages-select fastbot_waypoints --event-handler=console_direct+

echo "Tests complete. Exiting."
exit 0