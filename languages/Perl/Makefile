#.DEFAULT_GOAL := test

LANG=en_US

all: lint test

.PHONY: test
test:
	@prove -c

lint:
	@perl -MO=Lint,all $main.pl
	@perl -MO=Lint,all t/test.t
