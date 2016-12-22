FROM jupyter/scipy-notebook

USER root
RUN apt-get update \
    && apt-get -y install \
       build-essential cmake pkg-config \
       libjpeg62-turbo-dev libtiff5-dev libjasper-dev libpng12-dev \
       libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
       libxvidcore-dev libx264-dev \
       libatlas-base-dev gfortran \
       libhdf5-dev \
    && rm -rf /var/lib/apt/lists/*

ADD ./build_opencv.sh /tmp/

USER $NB_USER
RUN pip install numpy
RUN bash /tmp/build_opencv.sh

USER $NB_USER
