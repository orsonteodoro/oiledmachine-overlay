#!/usr/bin/env python
from __future__ import print_function
from future import standard_library
standard_library.install_aliases()
import sys
import os
import time
import tempfile
from sys import argv
from urllib.parse import urlparse

"""
def xdghome(key, default):
	'''Attempts to use the environ XDG_*_HOME paths if they exist otherwise
	use $HOME and the default path.'''

	xdgkey = "XDG_%s_HOME" % key
	if xdgkey in os.environ.keys() and os.environ[xdgkey]:
		return os.environ[xdgkey]

	return os.path.join(os.environ['HOME'], default)
"""

# Blockfile location.
BLOCKFILE = os.path.dirname(argv[0]) + "/adblock"
# Whitelist location
WHITELISTFILE = os.path.dirname(argv[0]) + "/whitelist"

def get_domain(url):
	'''Return domain segment of url.'''
	try:
		if not url.startswith('http'):
			url = "http://%s" % url
		loc = urlparse(url).netloc
		if loc.startswith('www.'):
			loc = loc[4:]
	except:
		loc=None
	return loc

def adblock(url, winid):
	fh = open(BLOCKFILE, 'r')
	lines = [line for line in fh]
	fh.close()

	fh = open(WHITELISTFILE, 'r')
	lines2 = [line for line in fh]
	fh.close()


	url = get_domain(url)
	rules = []
	rulesexclude = []
	exclude = False
	capture = False
	c=0
	for l in lines2:
		if url.find(l.strip()) > -1:
			sys.exit()
	for l in lines:
		c=c+1
		if l[0] != '\t' and len(l.strip()) > 0:
			d = None
			if l.strip().startswith('~'):
				exclude = True
				d = get_domain(l.strip()[1:])
				if d == url:
					capture = True
			if get_domain(l.strip()) == url or l.strip() == "global":
				capture = True
		elif not l.strip():
			capture = False
			exclude = False
		elif capture:
			l = l.strip()
			l = l.replace("'", "\\'")
			if exclude == False:
				rules.append(l.strip())
			else:
				print("exclude"+l.strip()+"\n")
				rulesexclude.append(l.strip())
	erulestr = ','.join(rulesexclude)
	rulestr = ','.join(rules)

	js = "(function() { var toblock = '"+ rulestr+"'; var toexclude = '"+ erulestr +"'; var style1 = document.createElement('style'); style1.innerHTML = toblock+' { display: none !important ; }'; document.head.appendChild(style1); var style2 = document.createElement('style'); style2.innerHTML = toexclude+' { display: default !important ; color: red; }'; document.head.appendChild(style2); })();\n"

	fd, filename = tempfile.mkstemp(prefix="surf_",dir="/tmp",text=True)
	fh = open(filename, "w")
	fh.write(js)
	fh.close()

	prop = "_SURF_SCRIPT"
	cmd = "xprop -id %s -f %s 8s -set %s \"%s\"" % (winid, prop, prop, filename)
	os.system(cmd)
	# Give some time to execute javascripts.
	time.sleep(2)
	# Remove script / cleanup.
	os.unlink(filename)

if __name__ == '__main__':
	if argv[2] is None:
		print("is none")
	#print "running adblock"
	#print "a"+str(len(argv[2]))
	#print "b"+str(len(argv[1]))
	adblock(get_domain(argv[2]), argv[1])
