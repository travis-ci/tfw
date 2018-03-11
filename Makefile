.PHONY: all
all: clean test

.PHONY: clean
clean:
	$(RM) -r tmp/*

.PHONY: distclean
distclean: clean
	$(RM) .deps-fetched

.PHONY: test
test: deps
	@echo noop

.PHONY: deps
deps: .deps-fetched

.deps-fetched:
	@date -u --iso-8601=s >$@
