#! /usr/bin/env python3

import sys
import subprocess

from lxml import etree


# requires utility tex2svg to be in the PATH
# this is a nodejs utility availble from:
# https://www.npmjs.com/package/mathjax-node-cli

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


for text in data.getroot().iter('{http://www.w3.org/2000/svg}text'):
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


try:
    outfile = sys.argv[2]
except:
    outfile = infile.replace('.svg', '_mathjax.svg')

with open(outfile, 'wb') as f:
    f.write(etree.tostring(data))


