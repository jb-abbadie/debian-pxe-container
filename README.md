# Automated Debian Install Container

A Docker image serving as a standalone PXE server and an automated preseed.

This PXE currently serves:
- Debian9

## Dependencies
These are the dependencies required to build and run the box:
- Docker 1.12+

## How to run

Build the image with your configuration :
`docker build -t pxe-debian .`

Create a config file like this :
```
DHCP_SERVER=192.168.1.1
PXE_SERVER=192.168.1.40
SERVER_IP=192.168.1.2
SERVER_HOSTNAME=server.example.com
SERVER_USER=user
SERVER_USER_SSH_KEY=ssh-rsa XXXXXXXXXXX
```

Then run the container with : `docker run -it --rm --cap-add NET_ADMIN --net=host --env-file env_file pxe-debian`

## Contributions
If you have suggestions, please create a new GitHub issue or a pull request.
