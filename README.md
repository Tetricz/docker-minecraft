# Docker-Minecraft
A lightweight container for running a minecraft server

Drop in your server.jar and hit run

## Quick-Run
```
docker run -e MEMORY=4G -v {yourdirectory}:/minecraft -p 25565:25565 tetricz/minecraft-server
```