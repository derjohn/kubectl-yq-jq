DKRIMAGE:=derjohn/kubectl-yq-jq
ARCH=amd64
DEBARCH=amd64
KUBECTL=v1.29.0
YQ=v4.40.5

.PHONY: docker-buildx docker-buildx-amd64 docker-buildx-arm64 docker-run dockerhub dockerhub-multiarch-manifest help

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo "You need a docker buildx builder with both architectures. Create it like this:"
	@echo "docker buildx create --name mybuilder ; docker buildx use mybuilder"

docker-buildx: ## [DEBARCH={amd64,arm64v8}] [ARCH={amd64,arm64}] [KUBECTL=vXXXX] [YQ=vXXXX]
	docker buildx build --no-cache --platform linux/$(ARCH) -t $(DKRIMAGE):$(ARCH)-latest -t $(DKRIMAGE):$(ARCH)-kubectl$(KUBECTL)-yq$(YQ) --build-arg ARCH=$(ARCH) --build-arg DEBARCH=$(DEBARCH) --build-arg KUBECTL=$(KUBECTL) --build-arg YQ=$(YQ) --load .

docker-buildx-amd64: ## Builds for amd64
	${MAKE} docker-buildx ARCH=amd64 DEBARCH=amd64

docker-buildx-arm64: ## Builds for arm64 (v8)
	${MAKE} docker-buildx ARCH=arm64 DEBARCH=arm64v8

docker-buildx-multi-arch: docker-buildx-amd64 docker-buildx-arm64 ## Make the multi-arch manifest (before publishing at dockerhub)

dockerhub: ## Make docker push to the repo in DKRIMAGE ($(DKRIMAGE))
	docker push $(DKRIMAGE):$(ARCH)-latest
	docker push $(DKRIMAGE):$(ARCH)-kubectl${KUBECTL}-yq${YQ}

dockerhub-multiarch-manifest: docker-buildx-multi-arch ## Push images for all ARCH to dockerhub and create a manifest
	${MAKE} dockerhub ARCH=amd64
	${MAKE} dockerhub ARCH=arm64
	docker manifest rm $(DKRIMAGE):latest
	docker manifest create $(DKRIMAGE):latest $(DKRIMAGE):amd64-latest $(DKRIMAGE):arm64-latest
	docker manifest push $(DKRIMAGE):latest

docker-run: ## [ARCH={amd64,arm64}]
	# docker run --entrypoint /bin/sh -it $(DKRIMAGE)
	docker run --platform linux/$(ARCH) -it $(DKRIMAGE):$(ARCH)-latest

