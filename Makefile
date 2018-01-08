

SOURCE=$(wildcard *.adoc)
INCLUDE_DIRS=css fig


ASCIIDOCTOR_OPTS=
ASCIIDOCTOR_OPTS+=-a linkcss
ASCIIDOCTOR_OPTS+=-a stylesdir=css
ASCIIDOCTOR_OPTS+=-a imagesdir=fig
ASCIIDOCTOR_OPTS+=-a scriptsdir=js
ASCIIDOCTOR_OPTS+=-a stem=latexmath
ASCIIDOCTOR_OPTS+=-a docinfo=shared
ASCIIDOCTOR_OPTS+=-a docinfodir=common
ASCIIDOCTOR_OPTS+=-a sectnums
ASCIIDOCTOR_OPTS+=-a stylesheet=asciidoctor.css


default: html


html: $(SOURCE:.adoc=.html)

#pdf: $(SOURCE:.adoc=.pdf)

web: html
	rsync -avuP --exclude='.*~' --delete \
	    $(INCLUDE_DIRS) *.html \
	    dan@tesla.whiteaudio.com:/var/www/www.agnd.net/tmp/guidebook/

guidebook.html: $(SOURCE) common/docinfo.html
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



