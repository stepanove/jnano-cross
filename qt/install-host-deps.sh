apt update

apt install -y pkg-config python

#wayland-scanner on the host is required to configure Qt with wayland support
apt install -y libwayland-dev

#For some reason host glib devel package is requred to configure Qt with -glib option
#apt install -y libglib2.0-dev
