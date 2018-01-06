

SOURCE=$(wildcard *.adoc)
OTHERDIRS=css fig


default: html


html: $(SOURCE:.adoc=.html)

web: html
	rsync -avuP --delete $(OTHERDIRS) *.html dan@tesla.whiteaudio.com:/var/www/www.agnd.net/tmp/guidebook/


%.html: %.adoc
	SOURCE_DATE_EPOCH=$(shell git log -1 --pretty=%ct) asciidoctor \
	    -a linkcss \
	    -a stylesdir=css/ \
	    -a stylesheet=asciidoctor.css $<



