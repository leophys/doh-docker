DOH-PROXY := rust-doh
DOH-BIN := $(DOH-PROXY)/target/debug/doh-proxy
DOH-BIN-LOCAL := bin/doh-proxy
IMAGE := doh-test

$(DOH-PROXY):
	@if [ ! -d $(DOH-PROXY) ]; then \
		git submodule init; \
	else \
		cd $(DOH-PROXY) && git pull; \
	fi

$(DOH-BIN-LOCAL): $(DOH-PROXY)
	cargo build --manifest-path $(DOH-PROXY)/Cargo.toml
	cp $(DOH-BIN) bin/

build: $(DOH-BIN-LOCAL)
	docker build -t $(IMAGE) .

run: build
	docker run -p 80:80 -p 443:443 $(IMAGE)
