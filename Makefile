

SOURCE=$(wildcard *.adoc)
INCLUDE_DIRS=css fig

FIGURES=$(wildcard fig/*)
CSSS=$(wildcard css/*)
COMMONS=$(wildcard common/*)

RESOURCES=$(FIGURES) $(CSSS) $(COMMONS)

ASCIIDOCTOR=bundle exec asciidoctor

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
GUIDEBOOK_TABLES=$(GUIDEBOOK_INCLUDES:.adoc=_tables.adoc)


define source_epoch
SOURCE_DATE_EPOCH=$(shell (git log -1 --pretty=%ct -- $(1); date +%s) | head -1)
endef


#default: dev
default: html


html: $(SOURCE:.adoc=.html) $(RESOURCES)

pdf: $(SOURCE:.adoc=.pdf)

#	    $(INCLUDE_DIRS) *.html \

web: html
	rsync -avuP \
	    --include='.htaccess' \
	    --exclude='.*' \
	    --exclude='Makefile' \
	    --delete-excluded \
	    --delete \
	    . \
	    dan@tesla.whiteaudio.com:/var/www/www.agnd.net/tourbook/

#fig: $(FIGURES)
fig:
	$(MAKE) -C fig


.PHONY: dev
dev: .dev

#windowactivate $$(xdotool search --onlyvisible --name "Electronics Tour Book")
#.dev: $(SOURCE:.adoc=.html)
#	-xdotool \
#	    windowactivate $$(xdotool search --desktop $$(xdotool get_desktop) --onlyvisible --name "Electronics.*") \
#	    key 'ctrl+r' \
#	    windowactivate $$(xdotool getwindowfocus) >/dev/null 2>&1
#	touch .dev

dev:
	(ls *.adoc | entr make & python -m http.server)

guidebook.html: $(SOURCE) $(GUIDEBOOK_INCLUDES) $(GUIDEBOOK_TABLES) common/docinfo.html

#guidebook.pdf: $(SOURCE)

%.xml: %.adoc
	$(call source_epoch, $<) $(ASCIIDOCTOR) \
	    -b docbook \
	    $(ASCIIDOCTOR_OPTS) \
	    $<

.SECONDARY:

%_tables.adoc: %.adoc
	./mk-tables.py $< > $@

%.html: %.adoc
	$(call source_epoch, $<) $(ASCIIDOCTOR) \
	    $(ASCIIDOCTOR_OPTS) \
	    $<

#%.pdf: %.adoc
#	$(call source_epoch, $<) asciidoctor-pdf \
#	    -r asciidoctor-mathematical \
#	    -a mathematical-format=svg \
#	    -a allow-uri-read \
#	    $(ASCIIDOCTOR_OPTS) \
#	    $<

#%.pdf: %.html
#	#specific fixup for htmlto and underlying phantomjs DPI issue
#	sed 's/<\/head>/<style>@media print{body{zoom:0.75;}}<\/style><\/head>/' $< > $<.tmp.html
#	~/node_modules/htmlto/bin/htmlto $<.tmp.html $@
#	rm $<.tmp.html

%.pdf: %.html
	#specific fixup for htmlto and underlying phantomjs DPI issue
	sed 's/<\/head>/<style>@media print{@page{margin:0.8in; size:8.5in 11in;}}<\/style><\/head>/' $< > $<.tmp.html
	google-chrome --headless --run-all-compositor-stages-before-draw --virtual-time-budget=1000 --print-to-pdf-no-header --print-to-pdf=$@ $<.tmp.html
	rm $<.tmp.html

