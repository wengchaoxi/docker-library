ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:-compute,utility}

RUN apt update && \
    apt install -y \
        wget build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev \
        libreadline-dev libffi-dev libsqlite3-dev libbz2-dev liblzma-dev \
        libmp3lame-dev libopus-dev \
        autoconf automake libass-dev libfreetype6-dev libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ARG FFMPEG_VERSION
ARG YASM_VERSION

RUN cd /tmp && \
    wget http://www.tortall.net/projects/yasm/releases/yasm-${YASM_VERSION}.tar.gz && \
    tar -xvf yasm-${YASM_VERSION}.tar.gz && \
    cd yasm-${YASM_VERSION} && \
    ./configure && \
    make && make install && \
    cd .. && rm yasm-${YASM_VERSION}.tar.gz && rm -r yasm-${YASM_VERSION} && \
    wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    tar -xvf ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    cd ffmpeg-${FFMPEG_VERSION} && \
    ./configure --enable-pic --enable-pthreads --enable-shared --enable-static \
        --enable-libmp3lame --enable-libopus --disable-doc --disable-nonfree && \ 
    make && make install && \
    echo "/usr/local/lib/" >> /etc/ld.so.conf && ldconfig && \
    cd .. && rm ffmpeg-${FFMPEG_VERSION}.tar.gz && rm -r ffmpeg-${FFMPEG_VERSION}

ARG PYTHON_VERSION

RUN cd /tmp && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xvf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make && make install && \
    cd .. && rm Python-${PYTHON_VERSION}.tgz && rm -r Python-${PYTHON_VERSION} && \
    ln -s /usr/local/bin/python3 /usr/local/bin/python && \
    ln -s /usr/local/bin/pip3 /usr/local/bin/pip && \
    python -m pip install --upgrade pip && \
    rm -r /root/.cache/pip

ARG PYTORCH_VERSION
ARG PYTORCH_VERSION_SUFFIX
ARG TORCHVISION_VERSION
ARG TORCHVISION_VERSION_SUFFIX
ARG TORCHAUDIO_VERSION
ARG TORCHAUDIO_VERSION_SUFFIX
ARG PYTORCH_DOWNLOAD_URL

RUN if [ ! $TORCHAUDIO_VERSION ]; \
    then \
        TORCHAUDIO=; \
    else \
        TORCHAUDIO=torchaudio==${TORCHAUDIO_VERSION}${TORCHAUDIO_VERSION_SUFFIX}; \
    fi && \
    if [ ! $PYTORCH_DOWNLOAD_URL ]; \
    then \
        pip install \
            torch==${PYTORCH_VERSION}${PYTORCH_VERSION_SUFFIX} \
            torchvision==${TORCHVISION_VERSION}${TORCHVISION_VERSION_SUFFIX} \
            ${TORCHAUDIO}; \
    else \
        pip install \
            torch==${PYTORCH_VERSION}${PYTORCH_VERSION_SUFFIX} \
            torchvision==${TORCHVISION_VERSION}${TORCHVISION_VERSION_SUFFIX} \
            ${TORCHAUDIO} \
            -f ${PYTORCH_DOWNLOAD_URL}; \
    fi && \
    rm -r /root/.cache/pip

WORKDIR /workspace
