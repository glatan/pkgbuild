SHELL := $(shell which bash)
NAME = makepkg
CONTAINER_NAME = registry.gitlab.com/glarch/container:makepkg
REPOSITORY_PATH = $(shell git rev-parse --show-toplevel)
WORKDIR = '/workdir'

.PHONY: p/pull
p/pull:
	@podman pull ${CONTAINER_NAME}

%.build: package/%/PKGBUILD
	@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} script/build.sh $@
	@podman rm $@

%.clean: package/%/PKGBUILD
	@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} script/clean.sh $@
	@podman rm $@

%.new: package/%/PKGBUILD
	@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} script/new.sh $@
	@podman rm $@

%.updpkgsums: package/%/PKGBUILD
	@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} script/updpkgsums.sh $@
	@podman rm $@

.PHONY: run-bash
run-bash:
	@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} bash
	@podman rm $@
