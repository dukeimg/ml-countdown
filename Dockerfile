FROM ubuntu:latest

# Install eng locale
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install OpenAI gym dependencies
RUN apt-get update && apt-get install -y python3-dev zlib1g-dev libjpeg-dev cmake swig python-pyglet python3-opengl \
    libboost-all-dev libsdl2-dev libosmesa6-dev patchelf ffmpeg xvfb

# Install essential tools
RUN apt-get update && apt-get install -y git nano python3-pip

# Install OpenAI
WORKDIR /root
RUN git clone https://github.com/openai/gym.git
WORKDIR /root/gym
RUN pip3 install numpy cffi Cython lockfile
RUN pip3 install -e '.[box2d]'

# Install Deep Learning stuff
RUN pip3 install matplotlib opencv-python keras tensorflow
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y python3-tk

# Run http server
RUN apt-get update && apt-get install -y apache2 ufw
RUN ufw allow 'Apache'
COPY html /var/www/html

COPY start.sh /root/start.sh
WORKDIR /root/gym

EXPOSE 80