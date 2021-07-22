#!/bin/bash
DIR=$(dirname "$(realpath "$BASH_SOURCE")")
source "$DIR/.common"

cd "$DIR/.."

title "Test development skeleton commands"

assert_cmd_info "Clean dev env before starting" bin/clean

function assert_clean_script() {
	info -n "Check container are deleted"
	for container in $CONTAINERS; do
		if [ $(docker ps -a -q -f "Name=^$container\$" | wc -l) -gt 0 ]; then
			succeed 1 -
		fi	
	done
	succeed 0 -
	
	info -n "Check images are deleted"
	for image in $IMAGES; do
		if [ $(docker image ls -a -q -f "reference=$image" | wc -l) -gt 0 ]; then
			succeed 1 -
		fi	
	done
	succeed 0 -
	
	info -n "Check docker network is deleted"
	if [ $(docker network ls -q -f "name=$REVERSE_PROXY_NETWORK" | wc -l) -gt 0 ]; then
		succeed 1 -
	fi	
	succeed 0 -
	
	info -n "Check environment files are deleted"
	if [ -f .env ] || [ -f var ] || [ -d var ]; then
		succeed 1 -
	else
		succeed 0 -	
	fi
}
assert_clean_script

echo

assert_cmd_info "Check bin/setup script" bin/setup
info -n "Check environment files are created"
if [ -f .env ] && [ -f var/ssl/cert.pem ] && [ -f var/ssl/key.pem ]; then
	succeed 0 -
else
	succeed 1 -	
fi

info -n "Check container are launched"
for container in $CONTAINERS; do
	if [ $(docker ps -q -f "Name=^$container\$" | wc -l) -eq 0 ]; then
		succeed 1 -
	fi	
done
succeed 0 -

echo

assert_cmd_info "Check bin/stop script" bin/stop
info -n "Check container are stopped"
for container in $CONTAINERS; do
	if [ $(docker ps -q -f "Name=^$container\$" | wc -l) -gt 0 ]; then
		succeed 1 -
	fi	
done
succeed 0 -
info -n "Check container are still present"
for container in $CONTAINERS; do
	if [ $(docker ps -a -q -f "Name=^$container\$" | wc -l) -eq 0 ]; then
		succeed 1 -
	fi	
done
succeed 0 -

echo 

assert_cmd_info "Check bin/start script" bin/start
info -n "Check container are launched"
for container in $CONTAINERS; do
	if [ $(docker ps -q -f "Name=^$container\$" | wc -l) -eq 0 ]; then
		succeed 1 -
	fi	
done
succeed 0 -

echo

assert_cmd_info "Check bin/logs script" bin/logs
assert_cmd_info "Check bin/restart script" bin/restart

echo

assert_cmd_info "Check bin/clean script" bin/clean
assert_clean_script