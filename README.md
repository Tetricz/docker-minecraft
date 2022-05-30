# Docker-Minecraft

A container running a Minecraft fabric server that will auto update mods using modrinth's API.

## Default mods added

* Fabric API
* Lithium
* Krypton
* Alternate Current

## Add mods to auto update script

Go to the Minecraft folder and open the updater folder. Open `modlist` with a text editor and add the project ID found on modrinth in the Technical Details section. Restart container to download the new mods and check for updates.

## Manual mod installation

Go to the Minecraft folder and open the updater folder. Create a text file called `modkeep` if not already there. Add the filename of the mod such as `/minecraft/mods/<filename>`. Then it should no longer be removed.

## Quick-Run

```bash
docker run -e MEMORY=4G -v {yourdirectory}:/minecraft -p 25565:25565 tetricz/minecraft-server:fabric-auto
```
