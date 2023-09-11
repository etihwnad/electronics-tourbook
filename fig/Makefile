SHELL=/bin/bash


# this is to make tex2svg from mathjax-node-cli show up in the PATH
# for the svgjax.py script
export PATH := $(HOME)/node_modules/.bin:$(PATH)


# convention to identify which SVGs need rendering
SVGMATHSOURCE=$(wildcard *_math.svg)
SVGMATHRENDER=$(SVGMATHSOURCE:_math.svg=.svg)

# render all IPE files to svg
IPESOURCE=$(wildcard *.ipe)
IPERENDER=$(IPESOURCE:.ipe=.svg)

default: all

all: svgmath ipe


ipe: $(IPERENDER)

svgmath: $(SVGMATHRENDER)

%.svg: %_math.svg
	./svgjax.py $< $@

%.svg: %.ipe
	iperender -svg $< $@.tmp.svg
	usvg --dpi 150 $@.tmp.svg $@ && rm $@.tmp.svg
