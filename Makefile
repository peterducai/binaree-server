.PHONY: test gen lint vendor-init vendor-update release

VERSION := `git vertag get`
COMMIT  := `git rev-parse HEAD`

ifeq ($(XDG_CONFIG_HOME),)
	XDG_CONFIG_HOME := $(HOME)/.config
endif

test:
	go test --race ./...

gen:
	go generate ./...

lint:
	gometalinter --config $(XDG_CONFIG_HOME)/gometalinter/config.json ./...

vendor-init:
	dep init

vendor-update:
	dep ensure && dep ensure -update

install:
	go install -a -ldflags "-X=main.version=$(VERSION) -X=main.commit=$(COMMIT)" ./...

release:
	git-vertag $(seg)
	goreleaser --rm-dist
