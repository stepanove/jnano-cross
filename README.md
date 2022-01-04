# An attempt to use docker container as Qt+OpenCV+CUDA development environment for Jetson Nano

The image built using these scripts and sysroot extracted from an official SD card image is available on docker hub:
```
docker pull stepanove/jnano-cross:qt5.15.2-opencv4.5.5
```
The idea is to use this image as a base with some folder on the host mounted as container's home:
```
docker run -ti \
-e DISPLAY=$DISPLAY \
--device=/dev/dri \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v /path/to/sysroot:/opt/jetson/sysroot \
-v /path/to/workspace:/home \
--name=jnano-cross-container \
stepanove/jnano-cross:qt5.15.2-opencv4.5.5
```
You also need to allow access to your X server, something like this:
```
xhost +
```
Then, within the container, add a user if you like (there is only root by default), install and configure required packages (QtCreator for example). All the changes will persist in this container (named "jnano-cross-container"). If you exit the container, it's not deleted by default, to start it again use:
```
docker start -ai jnano-cross-container
```

Optionally you can commit your changes into a new image and use it instead of stepanove/jnano-cross:qt5.15.2-opencv4.5.5
```
docker commit jnano-cross-container jnano-cross:configured
```

## jnano-cross
This folder contains scripts and dockerfiles used to build a container with CUDA cross-compiler, borrowed from [mxnet](https://github.com/apache/incubator-mxnet)

To build an image run following command in jnano-cross directory:
```
docker build -t jnano-cross -f Dockerfile.build.jetson .
```
Or pull it from docker hub:
```
docker pull stepanove/jnano-cross
```
## qt
This folder contains scripts and files used to cross-complie Qt within jnano-cross container. It expects target sysroot mounted to /opt/jetson/sysroot.
install-target-deps.sh can be used to install packages required to build the default Qt configuration, should be executed on Jetson Nano before extracting sysroot.


To build Qt you need to start a container:
```
docker run -ti -v /path/to/sysroot:/opt/jetson/sysroot -v /path/to/this/repo/:/workspace jnano-cross
```

Then run following commands in the container:
```
cd /workspace/qt 
./install-host-deps.sh
./build.sh 5.15.2
```
The first argument is Qt version (5.15.2 by default). Qt is installed into /usr/local/Qt${version}-jnano folder.
docker will assign some unique name to this container, you can get it with:
```
docker ps
```
or with:
```
docker ps -a
```
if the container is stopped

## opencv
There is a script that can be used to build an arbitrary OpenCV version (with CUDA support), it's supposed to run within the jnano-cross container. You can specify the required OpenCV version as the first argument (4.5.5 by default). It will installed into /usr/local/opencv-${version} folder.

```
cd /workspace/opencv
./build.sh 4.5.5

```
After building everything you need, you can create an image using:
```
docker commit {container_name} {image_tag}
```
## References

[Cross Compiling Qt for Embedded Systems](https://lifeofcode.net/)

[Qt 5.13 rc3 on the Nvidia Jetson Nano](https://chaos-reins.com/2019-06-19-jetson-nano/)

[Building Qt 5.15 LTS for Raspberry Pi on Raspberry Pi OS](https://www.tal.org/tutorials/building-qt-515-raspberry-pi)

[How to Cross Compile OpenCV and MXNET for NVIDIA Jetson (AArch64 CUDA)](https://medium.com/trueface-ai/how-to-cross-compile-opencv-and-mxnet-for-nvidia-jetson-aarch64-cuda-99d467958bce)
