#! /usr/bin/env python3

import sys
import subprocess

from lxml import etree


# requires utility tex2svg to be in the PATH
# this is a nodejs utility availble from:
# https://www.npmjs.com/package/mathjax-node-cli


OUTLINE_COLOR = '#00ff00'

TEXT_FONT_NAME = "'Noto Sans',Tahoma,Verdana,Arial,sans-serif"

try:
    infile = sys.argv[1]
except:
    infile = 'bjt-large-signal-model.svg'

data = etree.parse(infile)


def extract_svgjax(b, scale, transform):
    svg = etree.fromstring(b)

    #find all path and g nodes
    defs = svg.find('{*}defs')
    g = svg.find('{*}g')

    t = g.attrib['transform']
    s = 'scale(%f)' % scale
    g.attrib['transform'] = ' '.join([transform, s, t])

    return defs, g


root = data.getroot()


# find and replace all text containing math content
# identified with '$' as its first character
for text in root.iter('{*}text'):
    for e in text.iter():
        if e.text and e.text.strip().startswith('$'):
            tex = e.text.strip()[1:-1]

            cmd = subprocess.run(['tex2svg', tex],
                                 stdout=subprocess.PIPE,
                                 check=True)

            transform = text.attrib['transform']
            defs, g = extract_svgjax(cmd.stdout, 0.02, transform)
            parent = text.getparent()
            parent.replace(text,defs)
            parent.insert(parent.index(defs) + 1, g)


# change font of remaining text nodes
for text in root.iter('{*}text'):
    s = text.attrib.get('style')
    if s:
        text.attrib['style'] = s.replace('Arial', TEXT_FONT_NAME)
        text.attrib['style'] += ' font-stretch: extra-condensed;'


# find the outline box to extract the desired image dimensions
# This has no effect if there is no box
for box in root.iter('{*}rect'):
    if OUTLINE_COLOR in box.get('stroke'):
        w = float(box.attrib['width'])
        h = float(box.attrib['height'])
        sw = float(box.attrib['stroke-width'])

        # compensate for the width of the box itself since the original
        # calculations also take this into account
        width = w + sw
        height = h + sw

        #remove the box since it has served its purpose
        box.getparent().remove(box)

        # declare overall SVG to the box size
        root.attrib['width'] = str(width)
        root.attrib['height'] = str(height)

        # rescale the entire figure
        # find first g tag
        groot = root.find('{*}g')
        oldtransform = groot.attrib['transform']

        #extract scale factor from matrix transform
        a,b,c,d,e,f = oldtransform.split(',')

        # both a and d should be the same, but d should extract with less work
        #compute inverse scale factor
        scale = 'scale(%f)' % (1.0 / float(d))

        groot.attrib['transform'] = ' '.join((scale, oldtransform))
        break


try:
    outfile = sys.argv[2]
except:
    outfile = infile.replace('.svg', '_mathjax.svg')

with open(outfile, 'wb') as f:
    f.write(etree.tostring(data))
    f.write(b'\n')  # ensure there is an EOL character


