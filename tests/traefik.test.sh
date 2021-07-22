#!/bin/bash
DIR=$(dirname "$(realpath "$BASH_SOURCE")")
source "$DIR/.common"

cd "$DIR/.."

title "Test traefik container"

assert_cmd_info "Setup dev env" bin/setup
load_env

assert_url "https://traefik.${BASE_DOMAIN}/dashboard/#/"

info -n "Check traefik services"
wait_traefik_services "api@internal dashboard@internal noop@internal"
succeed 0 -

info -n "Check traefik docker services"
for container in $CONTAINERS; do
	wait_traefik_services "$container-id1-devhost@docker" 1
	if [ $? -gt 0 ]; then
		succeed 1 -
	fi
done
succeed 0 -

assert_cmd_info "Clean dev env" bin/clean