#!/usr/bin/env python
import sys
import os
import time
from sys import argv
from urlparse import urlparse

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

JAVASCRIPT = '''
(function() {
	var toblock = '%s';

        var style = document.createElement('style');
        style.innerHTML = toblock+' { display: none !important ; }';
        document.head.appendChild(style);
})();
'''
 
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
	capture = False
	c=0
	for l in lines2:
	        if url.find(l.strip()) > -1:
			sys.exit()
	for l in lines:
		c=c+1
		if l[0] != '\t' and len(l.strip()) > 0:
			if get_domain(l.strip()) == url or l.strip() == "global":
#			if get_domain(l.strip()) == url:
				capture = True
		elif not l.strip():
			capture = False
		elif capture:
			l = l.strip()
			l = l.replace("'", "\\'")
			rules.append(l.strip())

	rulestr = ','.join(rules)
	js = "%s\n" % (JAVASCRIPT % rulestr)

	filename = os.tempnam("/tmp", "surf_")
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
#	adblock(get_domain(argv[2]), argv[1])
