DOH-PROXY := rust-doh
DOH-BIN := $(DOH-PROXY)/target/debug/doh-proxy
DOH-BIN-LOCAL := bin/doh-proxy
IMAGE := doh-test
CONTAINER := local-doh

$(DOH-PROXY):
	if [ ! -d $(DOH-PROXY) ]; then \
		./gitsubmodules.sh; \
	else \
		git submodule update --init --recursive; \
	fi

$(DOH-BIN-LOCAL): $(DOH-PROXY)
	cargo build --manifest-path $(DOH-PROXY)/Cargo.toml
	cp $(DOH-BIN) bin/

build: $(DOH-BIN-LOCAL)
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
