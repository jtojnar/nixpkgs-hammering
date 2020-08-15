PREFIX ?= $(out)

INSTALL ?= install

build: foo

foo: foo.in
	cp $< $@

install: build
	$(INSTALL) -Dt $(PREFIX) foo
