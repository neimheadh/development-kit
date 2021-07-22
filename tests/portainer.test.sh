#!/bin/bash
DIR=$(dirname "$(realpath "$BASH_SOURCE")")
source "$DIR/.common"

cd "$DIR/.."
load_env

title "Test portainer container"

assert_cmd_info "Setup dev env" bin/setup
load_env

info -n "Check portainer traefik service"
wait_traefik_services "portainer-id1-devhost@docker"
succeed 0 -

sleep 10
assert_url "https://portainer.${BASE_DOMAIN}"

assert_cmd_info "Clean dev env" bin/clean