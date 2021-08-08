Neimheadh development kit
===========================

This repository contains a docker-based development environment. It gives to developers an ecosystem to their different 
projects container all the tools to develop web applications easily.

Included tools
--------------

All the following URL point to the different tools installed by the `bin/setup` script with the default configuration. 
If you changed the default configuration, or if you don't have installed the project yet, then the links will not work.

* [traefik](https://traefik.docker.localhost): handle projects containers hostname redirections. It listens new 
  containers in your local docker environment to give them an url (ex: https://my-project.docker.localhost).
* [portainer](https://portainer.docker.localhost): A web-based docker environment manager.
* [sonarqube](https://sonarqube.docker.localhost): A code-quality checker.
  
Dependencies
------------

This development kit was build and tested on Linux environments. It should be not compatible for Windows or macOS.

To works, this development kit needs following commands to be installed in your computer:

* `docker` (minimal version `17.12.0` -- see: [Get Docker | Docker Documentation](https://docs.docker.com/get-docker/))
* `docker-compose` (minimal version `1.10.0` -- see: 
  [Install Docker Compose | Docker Documentation](https://docs.docker.com/compose/install/))
* `sudo`: Used by the `setup` script to configure the system to makes sonarqube works (using `sysctl` and `ulimit`... 
  You have to have also.)
* `openssl`: To generate SSL cert & key files.
  
Getting started
---------------

To install the development kit, just clone it anywhere on your computer:

```
git clone https://github.com/neimheadh/development-kit.git
```

Then execute the `bin/setup` script :

```
cd development-kit
bin/setup
```

And... That's all. The links in paragraph [Included tools](#included-tools)
should now work.

Add your service
----------------

To add your service in traefik, just add it to the `${REVERSE_PROXY_NETWORK}` network (see configuration below) and set labels `traefik.enable` and 
`traefik.http.routers.{MY_SERVICE}.rule` as following :

```yaml
networks:
  front:
    external: true
    name: reverse-proxy

services:
  my_service:
    # [...]
    networks:
      - front
    labels:
      # Enable traefik resolve
      - traefik.enable=true
      # Set the service domain -- here my_service.docker.localhost
      - traefik.http.routers.my_service.rule=Host(`my_service.docker.localhost`)
```

If your service use multiple networks, you'll have to specify the network used by traefik with the label `traefik.docker.network`:

```yaml
networks:
  back:
    driver: bridge
  front:
    # [...]

services:
  my_services:
    # [...]
    networks:
      - front
      - back
    labels:
      # [...]
      - traefik.docker.network=front
```

Configuration
-------------

On `bin/setup` execution, it creates a `.env` file from the `.env.dist` file
with the changeable configuration variables. To change them you can edit a
previously created `.env` file or copy the `.env.dist` file to a new `.env`
file, change values and (re-)run `bin/setup`.

Here the list of changeable configuration variables:

| name | default | possible values | definition |
|------|---------|-----------------|------------|
| `SERVICES` | "traefik portainer sonarqube" | available space-separated service names in [docker-compose.yml](docker-compose.yml) file | Enabled development services | 
| `REVERSE_PROXY_NETWORK` | "reverse-proxy" | any | Docker network name used for the reverse-proxy (traefik) |
| `BASE_DOMAIN` | "docker.localhost" | any | Base domain name for all your containers |
| `PORTAINER_VERSION` | 1.23.2 | [A valid portainer image version](https://hub.docker.com/_/portainer) | The portainer image version for the portainer container |
| `TRAEFIK_VERSION` | v2.2.1 | [A valid traefik image version](https://hub.docker.com/_/traefik) | The traefik image version for the traefik container |
| `SONARQUBE_VERSION` | 8.3.1-community | [A valid sonarqube image version](https://hub.docker.com/_/sonarqube) | The traefik image version for the traefik container |
| `TRAEFIK_SSL_CERT_FILE` | "./var/ssl/cert.pem" | Any ssl cert file | The SSL cert file used by traefik |
| `TRAEFIK_SSL_KEY_FILE` | "./var/ssl/key.pem" | Any ssl key file | The SSL key file used by traefik |

Documentation
-------------

* [Scripts documentation](./bin/README.md): Describe development suite scripts and how they work.
