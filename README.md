# WAT
A openzwave panel ( GUI ) docker image for raspberry pi, running under ARM


# Run / use it

Get docker/docker-compose on our raspberry ( raspberian? ), e.g. use [this tutorial](https://github.com/EugenMayer/home-assistant-raspberry-zwave/wiki/1.1-Raspbian-OS-with-Docker#install-the-docker-engine)

```
docker pull eugenmayer/openzwave-panel
docker run --device=/dev/ttyAMA0:/dev/ttyAMA0 eugenmayer/openzwave-panel
```

while /dev/ttyAMA0 should reflect your tty UART port on your host. This one should fit a raspberry on a rpi with [disabled bluetooth](https://github.com/EugenMayer/home-assistant-raspberry-zwave/wiki/RPI3.-Raspberry-PI-3---GPIO-Zwave-controller-**only**:-Disable-Bluetooth), see.

# How its made
We are based on the official raspbian [docker image](resin/rpi-raspbian:jessie).

# Hot to run the image on a raspberry pi
See [this howto](https://github.com/EugenMayer/home-assistant-raspberry-zwave/wiki/1.1-Raspbian-OS-with-Docker) on how to get a raspberry pi ready for docker.

# Build it yourself

You have to run this build on an ARM based CPU!
You can use the prebuild one

```
docker pull eugenmayer/openzwave-panel
```

Of build it yourself

```
git clone https://github.com/EugenMayer/eugenmayer/openzwave-panel
cd eugenmayer/openzwave-panel
docker-compose build
```

on an RPI or likes
