# docker-dev-container

A docker container with a vim development environment. 

![Screenshot of vim running in a tmux session]
(./screenshot.jpeg)

## Features

- vim 8 customized with plugins and some other configured defaults (see [vimrc](./vimrc))
- Mosh 
- tmux with some light configurations (see [tmux](./tmux.conf))
- Node.js and TypeScript
- Elixir

## Quick Start

```sh
# Start the container
docker run -d --name dev-env-one \
  -v /path/to/projects:/projects \
  -e SSH_PASSWORD="mypassword"   \
  -p 1234:22                     \
  ronalddddd/dev-container

# Connect via SSH
ssh root@localhost -p 1234
```

## What is Mosh?

> Mosh is a replacement for interactive SSH terminals. It's more robust and responsive, especially over Wi-Fi, cellular, and long-distance links.


> keeps the session alive if the client goes to sleep and wakes up later, or temporarily loses its Internet connection

## Connecting via Mosh

- getting a mosh client: https://mosh.org/#getting
- you need to expose one or more UDP ports in the 6000 to 6100 range for
  mosh clients to connect
