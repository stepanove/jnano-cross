apt update
#These pacages should be installed on the target before pulling sysroot (https://www.tal.org/tutorials/building-qt-515-raspberry-pi)
apt install -y libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev libxcb-xinerama0-dev libxkbcommon-dev libxkbcommon-x11-dev libxcb-util-dev
apt install -y libgles2-mesa-dev libgbm-dev libdrm-dev
apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad libgstreamer-plugins-bad1.0-dev gstreamer1.0-pulseaudio gstreamer1.0-tools gstreamer1.0-alsa libwayland-dev
apt install -y pulseaudio libpulse-dev libasound2-dev
apt install -y libssl-dev libwayland-dev

#Tools to fix symlinks on the target fs (symlinks -c -r /) and extract sysroot via rsync
apt install -y openssh-server symlinks
