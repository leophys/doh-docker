DOH-PROXY := rust-doh
IMAGE := doh-test
CONTAINER := local-doh

$(DOH-PROXY):
	if [ ! -d $(DOH-PROXY) ]; then \
		./gitsubmodules.sh; \
	else \
		git submodule update --init --recursive; \
	fi

build:
	docker build -t $(IMAGE) .

run-detached: build
	docker run -p 80:80 -p 443:443 --name $(CONTAINER) -d $(IMAGE)

logs:
	docker logs -f $(CONTAINER)

run:
	make run-detached
	make logs

start-detached:
	docker container start $(CONTAINER)

start:
	make start-detached
	make logs

stop:
	docker container stop $(CONTAINER)

clean: stop
	docker container rm $(CONTAINER)
