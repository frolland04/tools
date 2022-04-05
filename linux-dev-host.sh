# System-wide APT package update
sudo apt-get update
sudo apt-get full-upgrade

# Specific packages for virtualized platforms
sudo apt-get install open-vm-tools open-vm-tools-desktop

# C/C++ base packages
sudo apt-get install build-essential gdb cmake clazy cppcheck csstidy tidy weblint-perl valgrind kcachegrind htop linux-tools-common

# CLI tooling
sudo apt-get install sysvbanner cowsay terminator terminology cool-retro-term konsole
sudo apt-get install tree pv dialog wget curl jq p7zip-full unzip cpio xz-utils rsync nano

# System and networking tools
sudo apt-get install snapd apt-utils diffstat chrpath socat locales debianutils findutils file time fontconfig strace lsof iputils-ping net-tools traceroute iperf

# Docker base packages
sudo apt-get install docker docker-compose

# GIT tooling
sudo apt-get install git git-lfs gitk git-gui git-cola qgit

# Various productivity tools
sudo apt-get install gparted inkscape gimp krita digikam gthumb thunar

# IDE and editors
sudo apt-get install kdevelop qtcreator meld kate gedit

# Python base packages
sudo apt-get install python3 python3-pip python3-venv python3-bs4 python3-serial python3-mysql.connector python3-mysqldb

# Specific libs and runtimes
sudo apt-get install pyqt5-dev nodejs npm sqlite3 rrdtool

# Specific Python packages reclaimed using PIP
sudo -H python3 -m pip install pip --upgrade
sudo -H python3 -m pip install setuptools --upgrade

# Specific packages reclaimed using SNAP
sudo snap install gitkraken
sudo snap install code
sudo snap install pycharm-community
