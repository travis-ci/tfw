SHELLCHECK_URL := https://www.googleapis.com/download/storage/v1/b/shellcheck/o/shellcheck-v0.4.7.linux.x86_64.tar.xz?alt=media
SHFMT_URL := https://github.com/mvdan/sh/releases/download/v2.2.0/shfmt_v2.2.0_linux_amd64

.PHONY: all
all: test

.PHONY: test
test:
	bats $(wildcard *.bats)

.PHONY: lint
lint:
	shellcheck tfw
	shfmt -i 2 -w tfw

.PHONY: ensure-shellcheck
ensure-shellcheck:
	if [[ $$(shellcheck --version | awk '/^version:/ { print $$2 }') != 0.4.7 ]]; then \
		curl -sSL -o "$(PWD)/tmp/shellcheck.tar.xz" "$(SHELLCHECK_URL)"; \
		tar -C "$(HOME)/bin" --exclude="*.txt" --strip-components=1 -xf "$(PWD)/tmp/shellcheck.tar.xz"; \
		shellcheck --version; \
	fi

.PHONY: ensure-shfmt
ensure-shfmt:
	if [[ $$(shfmt -version 2>/dev/null) != v2.2.0 ]]; then \
		curl -sSL "$(SHFMT_URL)" -o "$(HOME)/bin/shfmt"; \
		chmod +x "$(HOME)/bin/shfmt"; \
		shfmt -version; \
	fi
