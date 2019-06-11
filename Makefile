DOH-PROXY := rust-doh
IMAGE := doh-docker
DOH_CONTAINER ?= doh-docker
DOH_DOMAINS ?= localhost
DOH_EMAIL ?= test@email.me
DOH_UPSTREAM_DNS ?= 8.8.8.8:53
DOH_PATH ?= /doh
DOH_EXT_DOM := ""
DOH_DOCKER_OPTS := ""

$(DOH-PROXY):
	if [ ! -d $(DOH-PROXY) ]; then \
		./gitsubmodules.sh; \
	else \
		git submodule update --init --recursive; \
	fi

build:
	docker build -t $(IMAGE) .

run-detached: build
ifeq ($(DOH_DOMAINS),localhost)
	@echo "######################################################"
	@echo ""
	@echo "WARNING! Default value for DOH_DOMAINS: $(DOH_DOMAINS)"
	@echo ""
	@echo "######################################################"
endif
ifeq ($(DOH_EMAIL),test@email.me)
	@echo "######################################################"
	@echo ""
	@echo "WARNING! Default value for DOH_EMAIL: $(DOH_EMAIL)"
	@echo ""
	@echo "######################################################"
endif
ifneq ($(DOH_LE_VOL),"")
	@- $(foreach DOM,$(DOH_EXT_DOM), \
			$(eval DOH_DOCKER_OPTS += -v "/etc/letsencrypt/live/$(DOM)") \
			$(eval DOH_DOCKER_OPTS += -v "/etc/letsencrypt/archive/$(DOM)") \
		)
endif
	docker run -p 80:80 -p 443:443 \
		-e DOMAINS=$(DOH_DOMAINS) \
		-e EMAIL=$(DOH_EMAIL) \
		-e UPSTREAM_DNS=$(DOH_UPSTREAM_DNS) \
		-e DOH_PATH=$(DOH_PATH) \
		$(DOH_DOCKER_OPTS) \
		--name $(DOH_CONTAINER) -d $(IMAGE)

logs:
	docker logs -f $(DOH_CONTAINER)

run:
	make run-detached
	make logs

start-detached:
	docker container start $(DOH_CONTAINER)

start:
	make start-detached
	make logs

stop:
	docker container stop $(DOH_CONTAINER)

clean: stop
	docker container rm $(DOH_CONTAINER)
