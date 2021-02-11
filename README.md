# Valheim dedicated server

## Hosting a server

Running the docker image:

``` bash
docker run --rm -d --name=valheim-dedicated -p 2456:2456/udp -p 2457:2457/udp valheim:latest
```

Running with host interface:

``` bash
docker run --rm -d --name=valheim-dedicated --net=host valheim:latest
```

Using a volume to store the data (Recommended for world persistance):

``` bash
mkdir -p $(pwd)/valheim-docker
sudo chmod 777 $(pwd)/valheim-docker
docker run --rm -d -v $(pwd)/valheim-docker:/home/steam/valheim-server --name=valheim-dedicated --net=host valheim:latest
```

There are a number of environment variables that you should use to configure your server:

- STEAM_ADMIN_ID: Steam ID 64 (Dec) of the user to be admin. You can configure wore than one with "id1\nid2\nid3"
- SERVER_NAME: Your server name on the listing. Default "My awesome server"
- SERVER_PASSWORD: The server password. Default "1234secret!"
- SERVER_DATA_DIR: Directory to save the data, it defaults to a directory in the valheim-server.
- SERVER_WORLD: The world name to create. Default "Dedicated".
- SERVER_PORT: Server port, default 2456

To find your steam id use this webpage and copy the `steamID64 (Dec)` value: https://steamidfinder.com/
