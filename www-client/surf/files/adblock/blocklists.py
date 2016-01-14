#!/usr/bin/env python
import sys
import os
import time
from sys import argv
from urlparse import urlparse
import re
#import re2 as re
from string_matching import *
import json
import time
from multiprocessing import *
from multiprocessing.connection import *
import signal
import fcntl

# Blockfile location.
ADBLOCKFILE = os.path.dirname(argv[0]) + "/adblock"

d = {}
dg = []

def coldfilldata():
	fh = open(ADBLOCKFILE, 'r')
	lines = [line for line in fh]
	fh.close()

	mode = None
	capture = False
	mode = 'unknown'
	for l in lines: 
		l = l.strip()
		if l.find("exceptions") != -1:
			mode = 'exceptions'
			capture = True
		elif l.find("socketblock") != -1:
			mode = 'socketblock'
			capture = True
		elif len(l) == 0:
			mode = 'unknown'
			capture = False
		elif capture == True:
			p = l.strip()

			if len(p) == 0:
				continue
			if p.startswith('||') == True:
				p = l[2:]
			elif p.startswith('|') == True:
				p = l[1:]
			else:
				pp = p.strip()
				if mode == 'socketblock':
					pp = '@'+pp
				dg.append(pp)
				continue

			v = p
			if v.startswith('https'):
				v = v.replace('https://','')
			elif v.startswith('http'):
				v = v.replace('http://','')
			if v.find('/') > -1:
				v = v.split('/')[0]
			if v.find('^') > -1:
				v = v.split('^')[0]

			if v in d:
				v = v.replace('www.','')
				#print "domain="+v
				#print 'inserting'
				if mode == 'socketblock':
					p = '@'+p
				d[v].append(p)
			else:
				v = v.replace('www.','')
				#print "domain="+v
				#print 'new key + inserting'
				d[v] = []
				if mode == 'socketblock':
					p = '@'+p
				d[v].append(p)

	f = open('block1.dat', 'w')
	f.write(json.dumps(d))
	f.close()

	f = open('block2.dat', 'w')
	f.write(json.dumps(dg))
	f.close()

if __name__ == '__main__':
	global pmode
	global alive
	global loop
	global conn
	global listener

	pmode = 'server'
	alive = True
	loop = None
	conn = None
	listener = None

	eleurl = None
	mpurl = None

	coldfilldata()

