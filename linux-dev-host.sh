# System-wide APT package update
sudo apt update
sudo apt full-upgrade

# Specific packages for virtualized platforms
sudo apt install open-vm-tools open-vm-tools-desktop

# C/C++ base packages
sudo apt install build-essential gdb cmake ninja-build clazy cppcheck valgrind kcachegrind htop linux-tools-common 

# Qt tooling
sudo apt install qtcreator gammaray gammaray-plugin-positioning gammaray-plugin-bluetooth gammaray-plugin-quickinspector gammaray-plugin-waylandinspector clazy

# Web tooling
sudo apt install csstidy tidy weblint-perl

# CLI tooling
sudo apt install sysvbanner cowsay kitty fzf tree pv dialog wget curl jq p7zip-full unzip cpio xz-utils rsync nano vim sudo fontconfig msmtp

# System and networking tools
sudo apt install apt-utils diffstat chrpath socat locales debianutils findutils file time strace ltrace lsof iputils-ping net-tools traceroute iperf smbclient libssl-dev

# Filesystem tooling
sudo apt install exfat-fuse exfat-utils

# System tools GUI
sudo apt install terminator terminology cool-retro-term konsole systemd-bootchart bustle d-feet

# Docker base packages
sudo apt install docker docker-compose

# GIT tooling
sudo apt install git git-lfs gitk git-gui git-cola

# Various productivity tools
sudo apt install gparted inkscape gimp krita digikam darktable gthumb shotwell gwenview thunar dia libreoffice

# IDE and editors
sudo apt install kdevelop qtcreator meld kate gedit

# Python base packages
sudo apt install python3 python3-venv

# Interesting libs and runtimes
sudo apt install sqlite3 libsqlite3-dev rrdtool librrd-dev

# Interesting Python packages to install in virtual env
python3 -m pip install pip --upgrade
pip3 install setuptools black pylint mypy pywal bs4 serial mysql.connector --upgrade
