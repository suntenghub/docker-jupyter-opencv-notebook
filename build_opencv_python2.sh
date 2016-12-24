#!/bin/bash
set -euo pipefail

# thanks go to
# http://www.pyimagesearch.com/2016/10/24/ubuntu-16-04-how-to-install-opencv/

# specific to this environment:
CMAKE_INSTALL_PREFIX=/opt/conda/envs/python2
PYTHON_EXECUTABLE=/opt/conda/envs/python2/bin/python2.7

set -x

wget -q https://github.com/opencv/opencv/archive/3.1.0.zip -O /tmp/opencv-3.1.0.zip
wget -q https://github.com/opencv/opencv_contrib/archive/3.1.0.zip -O /tmp/opencv_contrib-3.1.0.zip
unzip -q /tmp/opencv-3.1.0.zip -d /tmp
unzip -q /tmp/opencv_contrib-3.1.0.zip -d /tmp

# download ippi proactively
# http://askubuntu.com/a/734846/36078
ippi_url=https://github.com/opencv/opencv_3rdparty/raw/ippicv/master_20151201/ippicv/ippicv_linux_20151201.tgz
ippi_dir=/tmp/opencv-3.1.0/3rdparty/ippicv/downloads/linux-808b791a6eac9ed78d32a7666804320e/
mkdir -p $ippi_dir
wget $ippi_url -O $ippi_dir/ippicv_linux_20151201.tgz

# patch for hdf5
# http://askubuntu.com/a/645089/36078
cd /tmp/opencv-3.1.0/modules/python
patch -p0 common.cmake <<'EOF'
133a134,137
> 
> find_package(HDF5)
> include_directories(${HDF5_INCLUDE_DIRS})
> 
EOF

mkdir /tmp/build
cd /tmp/build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D INSTALL_C_EXAMPLES=OFF \
      -D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib-3.1.0/modules \
      -D PYTHON_EXECUTABLE=$PYTHON_EXECUTABLE \
      -D BUILD_EXAMPLES=OFF \
      /tmp/opencv-3.1.0
make -j7
make install

# cleanup
rm -r /tmp/build /tmp/opencv*

