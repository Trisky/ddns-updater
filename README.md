# ddns-updater
DNS query based dynamic DNS updater. 

## Features

- Relies on `myip.opendns.com` and `ns1.google.com` for extra availability
- Doesn't rely on http calls but on [dig](https://linux.die.net/man/1/dig) to check the current IP through DNS lookup.
- Checks for IP change through dig every 10 seconds. 
- Published ARMv7 and LINUX64 images in [Docker hub](https://hub.docker.com/)
- Only logs on IP change or on errors, so you can `docker logs` and check when was the last failure.

## Usage

### docker-compose

```yaml
version: "3.8"
services:
  ddns-updater:
    image: trisky/ddns-updater
    restart: unless-stopped
    environment:
      - UPDATER_URL=${UPDATER_URL}
```

### Docker cli

```bash
docker run -d \
  --name=ddns-updater \
  -e UPDATER_URL="https://freedns.afraid.org/dynamic/update.php?XXXXXX==" \
  --restart unless-stopped \
  trisky/ddns-updater
```

## Limitations

- Don't run this if you have more than one internet connection and you use a load balancer as it will continually update your DDNS between your public IPs.

## ToDo:
- Add customizable check interval
