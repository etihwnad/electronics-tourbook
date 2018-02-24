

SOURCE=$(wildcard *.adoc)
INCLUDE_DIRS=css fig

FIGURES=$(wildcard fig/*)

ASCIIDOCTOR_OPTS=
ASCIIDOCTOR_OPTS+=-a linkcss
ASCIIDOCTOR_OPTS+=-a icons=font
ASCIIDOCTOR_OPTS+=-a stylesdir=css
ASCIIDOCTOR_OPTS+=-a imagesdir=fig
ASCIIDOCTOR_OPTS+=-a scriptsdir=js
ASCIIDOCTOR_OPTS+=-a stem=latexmath
ASCIIDOCTOR_OPTS+=-a docinfo=shared
ASCIIDOCTOR_OPTS+=-a docinfodir=common
ASCIIDOCTOR_OPTS+=-a sectnums
ASCIIDOCTOR_OPTS+=-a sectanchors
ASCIIDOCTOR_OPTS+=-a xrefstyle=full
ASCIIDOCTOR_OPTS+=-a stylesheet=asciidoctor.css


GUIDEBOOK_INCLUDES=$(shell grep -o -e '[^:<]\+\.adoc'  guidebook.adoc)

default: dev


html: $(SOURCE:.adoc=.html) $(FIGURES)

#pdf: $(SOURCE:.adoc=.pdf)

#	    $(INCLUDE_DIRS) *.html \

web: html
	rsync -avuP --exclude='.*' --delete-excluded --delete \
	    . \
	    dan@tesla.whiteaudio.com:/var/www/www.agnd.net/valpo/341/guidebook/

#fig: $(FIGURES)
fig:
	$(MAKE) -C fig


.PHONY: dev
dev: .dev

.dev: $(SOURCE:.adoc=.html)
	-xdotool \
	    windowactivate $$(xdotool search --onlyvisible --name "Tour Guide for Electronics") \
	    key 'ctrl+r' \
	    windowactivate $$(xdotool getwindowfocus) >/dev/null 2>&1
	touch .dev

guidebook.html: $(SOURCE) $(GUIDEBOOK_INCLUDES) common/docinfo.html

#guidebook.pdf: $(SOURCE)

%.xml: %.adoc
	SOURCE_DATE_EPOCH=$(shell git log -1 --pretty=%ct) asciidoctor \
	    -b docbook \
	    $(ASCIIDOCTOR_OPTS) \
	    $<

%.html: %.adoc
	SOURCE_DATE_EPOCH=$(shell git log -1 --pretty=%ct) asciidoctor \
	    $(ASCIIDOCTOR_OPTS) \
	    $<

#%.pdf: %.adoc
#	SOURCE_DATE_EPOCH=$(shell git log -1 --pretty=%ct) asciidoctor-pdf \
#	    -r asciidoctor-mathematical \
#	    -a mathematical-format=svg \
#	    -a allow-uri-read \
#	    $(ASCIIDOCTOR_OPTS) \
#	    $<

%.pdf: %.html
	~/node_modules/htmlto/bin/htmlto $< $@


