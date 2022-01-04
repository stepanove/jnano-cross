set -e
version=${1:-"4.5.5"}
folder="workspace"
echo "** Download opencv-"${version}

mkdir -p ${folder}
cd ${folder}

wget https://github.com/opencv/opencv/archive/${version}.zip -O opencv-${version}.zip
wget https://github.com/opencv/opencv_contrib/archive/${version}.zip -O opencv_contrib-${version}.zip
unzip opencv-${version}.zip
unzip opencv_contrib-${version}.zip

cd opencv-${version}/

mkdir build
cd build
# Fix cuda tetection (https://medium.com/trueface-ai/how-to-cross-compile-opencv-and-mxnet-for-nvidia-jetson-aarch64-cuda-99d467958bce)
echo 'set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")' | cat - ../cmake/OpenCVDetectCUDA.cmake > temp && mv temp ../cmake/OpenCVDetectCUDA.cmake

cmake \
-D CMAKE_INSTALL_PREFIX=/usr/local/opencv-${version} \
-D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda/targets/aarch64-linux \
-D CMAKE_TOOLCHAIN_FILE=../platforms/linux/aarch64-gnu.toolchain.cmake \
-D CMAKE_LIBRARY_PATH=/usr/local/cuda/targets/aarch64-linux/lib/stubs \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${version}/modules \
-D WITH_CUDA=ON \
-D opencv_cudev=ON \
-D CUDA_ARCH_BIN='5.3 6.2 7.2' \
-D BUILD_opencv_cudev=ON \
-D WITH_CAROTENE=OFF \
-D CMAKE_BUILD_TYPE=RELEASE \
-D BUILD_DOCS=OFF \
-D BUILD_EXAMPLES=OFF \
-D BUILD_opencv_apps=OFF \
-D BUILD_opencv_python2=OFF \
-D BUILD_opencv_python3=OFF \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_TESTS=OFF \
-D FORCE_VTK=OFF \
-D WITH_FFMPEG=OFF \
-D WITH_GDAL=OFF \
-D WITH_IPP=OFF \
-D WITH_OPENEXR=OFF \
-D WITH_OPENGL=OFF \
-D WITH_QT=OFF \
-D WITH_TBB=OFF \
-D WITH_XINE=OFF \
-D BUILD_JPEG=ON \
-D BUILD_ZLIB=ON \
-D BUILD_PNG=ON \
-D BUILD_TIFF=ON \
-D BUILD_BUILD_JASPER=OFF \
-D WITH_ITT=OFF \
-D WITH_LAPACK=OFF \
-D WITH_OPENCL=OFF \
-D WITH_TIFF=ON \
-D WITH_PNG=ON \
-D WITH_OPENCLAMDFFT=OFF \
-D WITH_OPENCLAMDBLAS=OFF \
-D WITH_VA_INTEL=OFF \
-D WITH_WEBP=OFF \
-D WITH_JASPER=OFF \
..


nproc | xargs -I % make -j% install

