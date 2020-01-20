SHELL := $(shell which bash)
CONTAINER_NAME = registry.gitlab.com/glarch/container:makepkg
WORKDIR = /workdir

.PHONY: p/pull
p/pull:
	@podman pull ${CONTAINER_NAME}

%.build: package/%/PKGBUILD
	-@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} script/build.sh $*
	@podman rm $@

%.new:
	-@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} script/new.sh $*
	@podman rm $@

%.updpkgsums: package/%/PKGBUILD
	-@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} script/updpkgsums.sh $*
	@podman rm $@

.PHONY: clean
clean:
	@git clean -dfX

.PHONY: run-bash
run-bash:
	-@podman run --name $@ -v .:${WORKDIR} -w ${WORKDIR} -it ${CONTAINER_NAME} bash
	@podman rm $@
