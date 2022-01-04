set -e

version=${1:-"5.15.2"}
majorversion=${version%.*}
folder="workspace"
SYSROOT=/opt/jetson/sysroot
INSTALL_DIR=/usr/local/Qt${version}-jnano

mkdir -p ${folder}
cd ${folder}
wget https://download.qt.io/official_releases/qt/${majorversion}/${version}/single/qt-everywhere-src-${version}.tar.xz

tar xf qt-everywhere-src-${version}.tar.xz

unzip -o ../linux-jetson-nano.zip -d qt-everywhere-src-${version}/qtbase/mkspecs/devices/

mkdir build
cd build 


#Apply a fix for libdrm.pc (https://chaos-reins.com/2019-06-19-jetson-nano/)
sed -i '/Libs:/c\Libs: -L${libdir} -L${libdir}/tegra -ldrm -ldrm -lnvll -lnvrm -lnvdc -lnvos -lnvrm_graphics -lnvimp' ${SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig/libdrm.pc
sed -i '/Cflags:/c\Cflags: -I${includedir} -I${includedir}/drm -I${includedir}/libdrm' ${SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig/libdrm.pc

../qt-everywhere-src-${version}/configure \
-opengl es2 \
-device linux-jetson-nano \
-device-option CROSS_COMPILE=aarch64-linux-gnu- \
-sysroot ${SYSROOT} \
-prefix  ${INSTALL_DIR} \
-extprefix ${INSTALL_DIR} \
-opensource \
-confirm-license \
-fontconfig \
-egl \
-xcb \
-glib \
-no-pch \
-nomake examples -no-compile-examples \
-nomake tests \
-ssl \
-v

nproc | xargs -I % make -j%
make  install
