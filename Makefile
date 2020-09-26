DKRIMAGE:=derjohn/kubectl-yq-jq


docker-build:
	docker build -t $(DKRIMAGE) .

docker-run:
	# docker run --entrypoint /bin/sh -it $(DKRIMAGE)
	docker run -it $(DKRIMAGE)

dockerhub:
	docker push $(DKRIMAGE)

