# tinhub: build and test with a tin checkout (TIN, default ../tin) and a tit checkout (TIT, default tit/).
#
#   make build    tinhub into bin/tinhub
#   make test     the test suite (unit tests everywhere; the Postgres checks need TINHUB_TEST_DB)
#
# TIN points at a checkout of usetin/tin (the compiler, runtime, std and packages); it is built from
# its checked-in seed when needed. TIT points at a checkout of usetin/tit; the test programs import
# its packages relatively, so the default is tit/ inside this repository.
TIN ?= ../tin
TIT ?= tit
TINC := $(TIN)/bin/tinc

.PHONY: all build test

all: build

build: $(TINC)
	@mkdir -p bin
	$(TIN)/tin build main.tin -o bin/tinhub

test: $(TINC)
	TIN_ROOT=$(abspath $(TIN)) TIT_ROOT=$(abspath $(TIT)) sh tests/run.sh $(abspath $(TINC))

$(TINC):
	$(MAKE) -C $(TIN) bin/tinc
