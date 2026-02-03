dpkg --add-architecture i386
mkdir -pm755 /usr/share/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /usr/share/keyrings/winehq-archive.key -
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources
apt update
apt install --install-recommends winehq-stable cabextract rar unrar p7zip
