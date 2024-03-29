[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/rockneurotiko/valheim)](https://hub.docker.com/r/rockneurotiko/valheim/) [![Docker Stars](https://img.shields.io/docker/stars/rockneurotiko/valheim.svg)](https://hub.docker.com/r/rockneurotiko/valheim/) [![Docker Pulls](https://img.shields.io/docker/pulls/rockneurotiko/valheim.svg)](https://hub.docker.com/r/rockneurotiko/valheim/) [![](https://img.shields.io/docker/image-size/rockneurotiko/valheim)](https://img.shields.io/docker/image-size/rockneurotiko/valheim)
# Valheim dedicated server

## Hosting a server

Running the docker image:

``` bash
docker run -d --restart always --name=valheim-dedicated -p 2456:2456/udp -p 2457:2457/udp rockneurotiko/valheim:latest
```

Running with host interface:

``` bash
docker run -d --restart always --name=valheim-dedicated --net=host rockneurotiko/valheim:latest
```

Using a volume to store the data (Recommended for world persistance):

``` bash
mkdir -p $(pwd)/valheim-server
sudo chmod 777 $(pwd)/valheim-server
docker run -d --restart always -v $(pwd)/valheim-server:/home/steam/valheim-server --name=valheim-dedicated --net=host rockneurotiko/valheim:latest
```

There are a number of environment variables that you should use to configure your server:

- STEAM_ADMIN_ID: Steam ID 64 (Dec) of the user to be admin. You can configure wore than one with "id1\nid2\nid3"
- SERVER_NAME: Your server name on the listing. Default "My awesome server"
- SERVER_PASSWORD: The server password. Default "1234secret!"
- SERVER_DATA_DIR: Directory to save the data, it defaults to a directory in the valheim-server.
- SERVER_WORLD: The world name to create. Default "Dedicated".
- SERVER_PORT: Server port, default 2456
- SERVER_CROSSPLAY: Enable crossplay, default true
- EXTRA_PARAMS: Pass extra params as provided to the valheim binary, default ""

To find your steam id use this webpage and copy the `steamID64 (Dec)` value: https://steamidfinder.com/

## Valheim Plus

This docker has a tag `plus` that integrates [Valheim Plus](https://valheim.plus/).

With Valheim Plus there are no Crossplay, and the default world name is "DedicatedPlus"

For example:

``` bash
docker run -d --restart-always --name=valheim-dedicated-plus --net=host rockneurotiko/valheim:plus
```

## Example

Just to show a real world example, this is how I manage my own servers.

Before anything, you need to create a directory for the docker volume:

``` bash
mkdir -p $(pwd)/valheim-server
sudo chmod 777 $(pwd)/valheim-server
```

Then I have a script that stop && start the docker, useful for start or restart the server and for update.

``` bash
#!/bin/sh

# Configure the following directories
valheim_dir="/home/rock/valheim-server"
backup_dir="/home/rock/backups/$(date +%Y-%m-%d)"

data_dir="${valheim_dir}/data"

echo "---------------------------------------" >> server.logs
echo "Restarting $(date)" >> server.logs

echo "Stopping server" >> server.logs
docker stop valheim-dedicated >> server.logs 2>&1

if [ -d "$data_dir" ]; then
  echo "Backup data to $backup_dir" >> server.logs
  cp -r "$data_dir" "$backup_dir" >> server.logs 2>&1
else
  echo "Backup skipped, data dir doesn't exists $data_dir" >> server.logs
fi

if [ $? -ne 0 ]; then
  echo "Error doing the backup, not starting the server." >> server.logs
  exit 1
fi

echo "Starting server" >> server.logs
docker start valheim-dedicated >> server.logs 2>&1 || docker run -d --restart always -v $valheim_dir:/home/steam/valheim-server --name=valheim-dedicated -e SERVER_NAME="My Server Name" -e SERVER_PASSWORD="MyPassword" -e STEAM_ADMIN_ID="<id>" --net=host rockneurotiko/valheim:latest >> server.logs 2>&1

echo "End" >> server.logs
```

Replace the path of the volume directory (`/home/rock/valheim-server`) for your own path, and change the environment values (server name, password, admin, ...)

Start the server executing the script: `./start.sh`

For stability, I have configured a restart a 05:00 AM UTC using cron, this is my crontab line (You need the PATH in order to find the docker command):

``` text
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
0 5 * * * /home/rock/start.sh
```
