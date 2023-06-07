# Generic fpc Makefile, originally created for deash
# Author: Marie Eckert

SOURCE=src
MAIN=$(SOURCE)/deash.pp
OUT=out
INC=src/inc:src/extra:src/deash_core

all: clean build
debug: clean build_debug

clean:
	mkdir -p out/
	-rm out/*
build_debug:
	fpc $(MAIN) -FE"$(OUT)" -Fu"$(INC)" -g -dDEBUG
build:
	fpc $(MAIN) -FE"$(OUT)" -Fu"$(INC)" -O4 -XX -Xs
