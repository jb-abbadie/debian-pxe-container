# Automated Debian Install Container

A Docker image serving as a standalone PXE server and an automated preseed.

This PXE currently serves:
- Debian9

## Dependencies
These are the dependencies required to build and run the box:
- Docker 1.12+

## How to run

Build the image with your configuration :
`docker build .`

Then run the container with : `docker run -it --rm --net=host xxxxxxxxx`

## How to modify the configuration
Either edit the Dockerfile or the build args.
DHCP_SERVER
PXE_SERVER
SERVER_HOSTNAME
SERVER_USER
SERVER_USER_SSH_KEY
SERVER_IP

## Contributions
If you have suggestions, please create a new GitHub issue or a pull request.
