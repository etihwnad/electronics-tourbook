SHELL=/bin/bash


# this is to make tex2svg from mathjax-node-cli show up in the PATH
# for the svgjax.py script
export PATH := $(HOME)/node_modules/.bin:$(PATH)


# convention to identify files which need rendering
SVGMATHSOURCE=$(wildcard *_math.svg)
SVGMATHRENDER=$(SVGMATHSOURCE:_math.svg=.svg)



svgmath: $(SVGMATHRENDER)

%.svg: %_math.svg
	./svgjax.py $< $@
