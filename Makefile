PLATFORMS	?= linux/amd64,linux/arm/v7
REPO	?= suet/dnsmaq
TAG	?= latest

build: Dockerfile
	@docker build -t $(REPO):$(TAG) .

.buildx:
	@if ! docker help|grep -q buildx; then \
		echo buildx is not available; \
	elif ! docker buildx inspect --bootstrap multi; then \
		echo Creating multi builder for buildx; \
		docker buildx create --name multi --use; \
		echo Bootstrapping multi builder for buildx; \
		docker buildx use multi; \
		docker buildx inspect --bootstrap multi; \
	fi
	docker buildx ls
	docker buildx build --platform $(PLATFORMS) -t $(REPO):$(TAG) --push .

buildx: Dockerfile .buildx
	$(RM) .buildx
