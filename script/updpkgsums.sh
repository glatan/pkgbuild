#!/usr/bin/env bash

set -u

cd "package/${1}" || exit

chown -R makepkg ./

su makepkg -c 'updpkgsums'

chown -R root ./
