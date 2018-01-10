

SOURCE=$(wildcard *.adoc)
INCLUDE_DIRS=css fig


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
ASCIIDOCTOR_OPTS+=-a stylesheet=asciidoctor.css


default: html


html: $(SOURCE:.adoc=.html) fig

#pdf: $(SOURCE:.adoc=.pdf)

#	    $(INCLUDE_DIRS) *.html \

web: html
	rsync -avuP --exclude='.*~' --delete-excluded --delete \
	    . \
	    dan@tesla.whiteaudio.com:/var/www/www.agnd.net/valpo/341/guidebook/

.PHONY: fig
fig:
	$(MAKE) -C fig


guidebook.html: $(SOURCE) common/docinfo.html fig

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
#	    -a allow-uri-read \
#	    $(ASCIIDOCTOR_OPTS) \
#	    $<



