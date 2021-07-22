Neimheadh development kit -- scripts
======================================

The current repository directory contains bash scripts used to work with the development kit. The current documentation
describes each scripts in the directory and their options.

`.common`: The list of common functions of scripts.
---------------------------------------------------

This script is not an executable script but contains bash functions used by other scripts:

* `_echo`: A classic `echo` wrapper taking a color to make a colorful output.
* `load_env`: Load the `.env` file into bash variables to make them usable by scripts.
* `info`: `echo` with info color.
* `title`: `echo` with title color & style.
* `echo_cmd`: `echo` with command color.
* `cmd`: `echo_cmd` the given command and execute it.
* `error`: `echo` with error color.

`clean`: Clear the development environment
------------------------------------------

This script clear the docker environment (containers, volumes, network & images) and temporary files.

It doesn't take any option or arg.

`logs`: Log container output
----------------------------

This script is just a wrapper for the `docker-compose logs` command. Its only benefit is to place you in the development
kit directory before executing the `docker-compose logs`, so you're able to call it everywhere.

It does take the same options and args than the `docker-compose logs` command, so you can have options executing :

```
bin/logs --help
View output from containers.

Usage: logs [options] [--] [SERVICE...]

Options:
    --no-color              Produce monochrome output.
    -f, --follow            Follow log output.
    -t, --timestamps        Show timestamps.
    --tail="all"            Number of lines to show from the end of the logs
                            for each container.
    --no-log-prefix         Don't print prefix in logs.
```

`restart`: Restart containers
-----------------------------

This script restart development kit containers. It only executes the `stop` script then the `start` script with no
parameters. If you need to make a more complicated `stop` or `start`, then you'll have to use these scripts directly
instead.

It doesn't take any option or arg.

`setup`: Setup development environment
--------------------------------------

Set up the development kit. The script does followings things :

* Copy the `.env.dist` file into a `.env` file if the `.env` file doesn't already exist.
* Create the `REVERSE_PROXY` network if it doesn't exist.
* Generate the `TRAEFIK_SSL_CERT_FILE` and the `TRAEFIK_SSL_KEY_FILE` if the `TRAEFIK_SSL_CERT_FILE` doesn't already
  exist. **WARNING**: If the `TRAEFIK_SSL_CERT_FILE` doesn't exist, the `TRAEFIK_SSL_KEY_FILE` will be re-generated even if it 
  exists.
* Configure environment to make SonarQube work.
* Build docker images.
* Execute `start` script.

It doesn't take any option or arg.

`start`: Start development kit
-------------------------------

Start development kit containers (removing orphans) in background.

The script gives arguments you give to it to the `docker-compose up --remove-orphans -d` command it executes. So you
can use all options and args `docker-compose up` command has :

```
bin/start --help

 Start developpement environnement containers
----------------------------------------------

Builds, (re)creates, starts, and attaches to containers for a service.

Unless they are already running, this command also starts any linked services.

The `docker-compose up` command aggregates the output of each container. When
the command exits, all containers are stopped. Running `docker-compose up -d`
starts the containers in the background and leaves them running.

If there are existing containers for a service, and the service's configuration
or image was changed after the container's creation, `docker-compose up` picks
up the changes by stopping and recreating the containers (preserving mounted
volumes). To prevent Compose from picking up changes, use the `--no-recreate`
flag.

If you want to force Compose to stop and recreate all containers, use the
`--force-recreate` flag.

Usage: up [options] [--scale SERVICE=NUM...] [--] [SERVICE...]

Options:
    -d, --detach               Detached mode: Run containers in the background,
                               print new container names. Incompatible with
                               --abort-on-container-exit.
    --no-color                 Produce monochrome output.
    --quiet-pull               Pull without printing progress information
    --no-deps                  Don't start linked services.
    --force-recreate           Recreate containers even if their configuration
                               and image haven't changed.
    --always-recreate-deps     Recreate dependent containers.
                               Incompatible with --no-recreate.
    --no-recreate              If containers already exist, don't recreate
                               them. Incompatible with --force-recreate and -V.
    --no-build                 Don't build an image, even if it's missing.
    --no-start                 Don't start the services after creating them.
    --build                    Build images before starting containers.
    --abort-on-container-exit  Stops all containers if any container was
                               stopped. Incompatible with -d.
    --attach-dependencies      Attach to dependent containers.
    -t, --timeout TIMEOUT      Use this timeout in seconds for container
                               shutdown when attached or when containers are
                               already running. (default: 10)
    -V, --renew-anon-volumes   Recreate anonymous volumes instead of retrieving
                               data from the previous containers.
    --remove-orphans           Remove containers for services not defined
                               in the Compose file.
    --exit-code-from SERVICE   Return the exit code of the selected service
                               container. Implies --abort-on-container-exit.
    --scale SERVICE=NUM        Scale SERVICE to NUM instances. Overrides the
                               `scale` setting in the Compose file if present.
    --no-log-prefix            Don't print prefix in logs.
```

`stop`: Stop development kit containers
---------------------------------------

Stop development kit containers.

The script gives arguments you give to it to the `docker-compose stop` command it executes. So you can use all options 
and args `docker-compose stop` command has :

```
bin/stop --help

 Stop developpement environnement containers
---------------------------------------------

Stop running containers without removing them.

They can be started again with `docker-compose start`.

Usage: stop [options] [--] [SERVICE...]

Options:
  -t, --timeout TIMEOUT      Specify a shutdown timeout in seconds.
                             (default: 10)
```

`test`: Test the development kit scripts
----------------------------------------

This script is a development script. It'll execute scripts located in the `/tests` directory, failing as soon as one
fail.

It doesn't take any option or arg.