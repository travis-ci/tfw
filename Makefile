SHELL := bash
TMPDIR ?= /tmp

SHELLCHECK_URL := https://www.googleapis.com/download/storage/v1/b/shellcheck/o/shellcheck-v0.4.7.linux.x86_64.tar.xz?alt=media
SHFMT_URL := https://github.com/mvdan/sh/releases/download/v2.2.0/shfmt_v2.2.0_linux_amd64

.PHONY: all
all: test

.PHONY: clean
clean:
	@: noop

.PHONY: test
test:
	bats $(wildcard *.bats)

.PHONY: lint
lint:
	checkmake Makefile &>/dev/null
	shfmt -f . | xargs shellcheck
	shfmt -i 2 -w .

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

.PHONY: usage
usage:
	echo '# Usage' >>USAGE.md
	./tfw help | awk -F'[ ,]+' '/^  [a-z]/{printf "\n## tfw help %s\n\n```sh\n", $$2; system("./tfw help "$$2);print "```"}' >>USAGE.md
