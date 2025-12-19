# Start from ROS base image
FROM osrf/ros:humble-desktop-full

# Make a catkin workspace
RUN mkdir -p /home/catkin_ws/src/simulation

# Exporting a variable to install pkgs without any interactive questions
ENV DEBIAN_FRONTEND=noninteractive

# Install Git & other things
RUN apt-get update && apt-get install -y \
    git \
	ros-humble-gazebo-ros-pkgs

COPY ./fastbot_description /home/catkin_ws/src/fastbot_description
COPY ./fastbot_gazebo /home/catkin_ws/src/fastbot_gazebo
COPY ./fastbot_waypoints /home/catkin_ws/src/fastbot_waypoints

RUN /bin/bash -c "source /opt/ros/humble/setup.bash \
    && cd /home/catkin_ws \
    && colcon build"

# Add sourcing to bashrc so it happens automatically in every shell
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc \
    && echo "source /home/catkin_ws/install/setup.bash" >> ~/.bashrc

RUN chmod +x /home/catkin_ws/src/fastbot_waypoints/src/fastbot_system_test/fastbot_tester.py

# Copy entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]