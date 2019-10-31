SHELL := $(shell which bash)
NAME = makepkg
CONTAINER_NAME = registry.gitlab.com/glarch/container:makepkg
REPOSITORY_PATH = $(shell git rev-parse --show-toplevel)

.PHONY: docker-pull
docker-pull:
	@docker pull ${CONTAINER_NAME}

.PHONY: docker-run
docker-run:
	@# If there is a makepkg container running, then it is removed. After that, rerun it.
	@# If there is not makepkg container, run it.
	$(if $(shell docker ps | grep ${NAME}), \
		$(shell docker stop ${NAME} > /dev/null) \
		$(shell docker rm ${NAME} > /dev/null) \
	, \
	)
	@docker run -itd --name ${NAME} \
		--mount type=bind,src=${REPOSITORY_PATH},dst=/makepkg \
		--workdir /makepkg ${CONTAINER_NAME}

.PHONY: docker-exec
docker-exec:
	@docker exec -it ${NAME} /usr/bin/bash 

.PHONY: build
build:
	$(if ${ARG},, \
		$(error Build target is not selected) \
	)
	$(info Build target: ${ARG})
	@docker exec ${NAME} /makepkg/script/build.sh ${ARG}

.PHONY: clean
clean:
	@docker exec ${NAME} /makepkg/script/clean.sh ${ARG}

.PHONY: new
new:
	@docker exec ${NAME} /makepkg/script/new.sh ${ARG}

.PHONY: updpkgsums
updpkgsums:
	@docker exec ${NAME} /makepkg/script/build.sh --updpkgsums ${ARG}
