# minecraft-docker-image
Minecraft Docker Image

## Usage

### Start

`docker compose up -d`

### Attach

`docker attach <container-name>`

E.g. `docker attach minecraft-docker-image-server-1`

### Detach

`Ctrl-p`, `Ctrl-q`

## Configuration

### Port

Change `ports` in `docker-compose.yml` to expose your minecraft server on your own port ("your-own-port:25565", e.g. "32123:25565".)

### Memory

Change `-Xms256M` and `-Xmx2G` in `Dockerfile` in `CMD`.

Also change `mem_limit` in `docker-compose.yml`.

### Project Name

Change project name for running multiple containers.

Using `docker compose -p <project-name> up -d` to run your container with a custom name.

E.g. `docker compose -p jasmine up -d`, then you can run `docker attach jasmine-server-1` to attach to the server console.
