SHELL := bash
TMPDIR ?= /tmp
RUNDIR ?= /tmp/travis-run.d
PREFIX ?= /usr/local

SHELLCHECK_URL := https://www.googleapis.com/download/storage/v1/b/shellcheck/o/shellcheck-v0.4.7.linux.x86_64.tar.xz?alt=media
SHFMT_URL := https://github.com/mvdan/sh/releases/download/v2.2.0/shfmt_v2.2.0_linux_amd64

TOP := $(shell git rev-parse --show-toplevel)

.PHONY: all
all: test

.PHONY: clean
clean:
	@: noop

.PHONY: test
test:
	bats $(wildcard *.bats)

.PHONY: systest
systest: .assert-ci
	sudo -H DEBUG=1 RUNDIR=$(RUNDIR) $(TOP)/bin/tfw bootstrap
	sudo -H DEBUG=1 RUNDIR=$(RUNDIR) $(TOP)/bin/tfw admin-bootstrap

.PHONY: sysseed
sysseed: .assert-ci
	mkdir -p $(RUNDIR)
	rsync -av $(TOP)/.testdata/rundir/ $(RUNDIR)

.PHONY: deps
deps: ensure-checkmake ensure-shellcheck ensure-shfmt
	pip install -r requirements.txt

.PHONY: lint
lint:
	checkmake Makefile &>/dev/null
	shfmt -f bin/ | xargs shellcheck
	shfmt -i 2 -w bin/
	yapf -i -r -vv bin/

.PHONY: ensure-checkmake
ensure-checkmake:
	if ! checkmake --version &>/dev/null; then \
		go get github.com/mrtazz/checkmake; \
		pushd $${GOPATH%%:*}/src/github.com/mrtazz/checkmake; \
		make all install PREFIX=$(HOME); \
		popd; \
	fi

.PHONY: ensure-shellcheck
ensure-shellcheck:
	if [[ $$(shellcheck --version | awk '/^version:/ { print $$2 }') != 0.4.7 ]]; then \
		curl -sSL -o "$(TMPDIR)/shellcheck.tar.xz" "$(SHELLCHECK_URL)"; \
		tar -C "$(HOME)/bin" --exclude="*.txt" --strip-components=1 -xf "$(TMPDIR)/shellcheck.tar.xz"; \
		shellcheck --version; \
	fi

.PHONY: ensure-shfmt
ensure-shfmt:
	if [[ $$(shfmt -version 2>/dev/null) != v2.2.0 ]]; then \
		curl -sSL "$(SHFMT_URL)" -o "$(HOME)/bin/shfmt"; \
		chmod +x "$(HOME)/bin/shfmt"; \
		shfmt -version; \
	fi

USAGE.md: bin/tfw
	echo '# Usage' >$@
	./bin/tfw list-internal-commands | \
		LC_ALL=C sort | \
		awk '{ \
			printf "\n## tfw help %s\n\n```\n", $$1; \
			system("./bin/tfw help "$$1); \
			print "```" \
		}' >>$@

.PHONY: install
install:
	install -D -m 0755 -t $(PREFIX)/bin $(wildcard bin/*)

.PHONY: .assert-ci
.assert-ci:
	@[[ "$(TRAVIS)" && "$(CI)" ]] || { \
		echo 'ERROR: $$TRAVIS and $$CI not detected!'; \
		exit 1; \
	}
