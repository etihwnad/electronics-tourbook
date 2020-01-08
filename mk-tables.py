#!/usr/bin/env python3

# (C) 2020 Dan White
# MIT license

# usage:
#   mk-tables.py document.adoc > document_tables.adoc
#
# then in document.adoc, place a heading and
#   include::document_tables.adoc[]
# to add a listing of tables

# idea from:
# https://github.com/asciidoctor/asciidoctor-extensions-lab/issues/111#issuecomment-542798266

import sys
from itertools import tee

def usage():
    print("""usage:
   mk-tables.py document.adoc > document_tables.adoc

 then in document.adoc, place a heading and
   include::document_tables.adoc[]
 to add a listing of tables with links to the document.""")


def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return zip(a, b)


if len(sys.argv) != 2:
    usage()
    sys.exit(1)


with open(sys.argv[1]) as f:
    for first, second in pairwise(f):
        if first.startswith('.') and second.startswith('[#t-'):
            title = first.strip()[1:]
            label = second[2:].strip()[:-1]
            # s = f'<<{label}>> : <<{label}, {title}>> +'
            s = f'<<{label}>> +'
            print(s)

