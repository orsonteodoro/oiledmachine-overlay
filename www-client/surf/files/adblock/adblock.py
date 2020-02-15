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

BLACKLIST_PATH = os.path.dirname(argv[0]) + "/adblock"
WHITELIST_PATH = os.path.dirname(argv[0]) + "/whitelist"

def get_domain(url):
	'''
	Return the domain segment of the URL.

	Parameters
	----------
	url : str
		A raw url.

	Returns
	-------
	str
		The domain name without the www. prefix.
	'''
	try:
		if not url.startswith('http'):
			url = "http://%s" % url
		loc = urlparse(url).netloc
		if loc.startswith('www.'):
			loc = loc[4:]
	except:
		loc = None
	return loc

def generate_javascript_adblocker(url, winid):
	'''
	Generates JavaScript to remove ad elements.

	Parameters
	----------
	url : str
		The URL of the webpage.
	winid : src
		The window ID to send back the JavaScript code fragment.

	Returns
	-------
		None
	'''
	file_handle = open(BLACKLIST_PATH, 'r')
	lines_blockfile = [line for line in file_handle]
	file_handle.close()

	file_handle = open(WHITELIST_PATH, 'r')
	lines_whitelist = [line for line in file_handle]
	file_handle.close()

	url = get_domain(url)
	rules_include = []
	rules_exclude = []
	exclude = False
	capture = False
	for line in lines_whitelist:
		if url.find(line.strip()) > -1:
			sys.exit()
	for line in lines_blockfile:
		if line[0] != '\t' and len(line.strip()) > 0:
			domain = None
			if line.strip().startswith('~'):
				exclude = True
				domain = get_domain(line.strip()[1:])
				if domain == url:
					capture = True
			if get_domain(line.strip()) == url \
				or line.strip() == "global":
				capture = True
		elif not line.strip():
			capture = False
			exclude = False
		elif capture:
			line = line.strip()
			line = line.replace("'", "\\'")
			if exclude == False:
				rules_include.append(line.strip())
			else:
				rules_exclude.append(line.strip())
	exclude_rule_string = ','.join(rules_exclude)
	include_rule_string = ','.join(rules_include)

	js = '''
(function() {
	var toBlock = '%s';
	var toExclude = '%s';
	var styleBlock = document.createElement('style');
	styleBlock.innerHTML = toBlock + ' { display: none !important ; }';
	document.head.appendChild(styleBlock);
	var styleExclude = document.createElement('style');
	styleExclude.innerHTML = toExclude
		+ ' { display: default !important ; color: red; }';
	document.head.appendChild(styleExclude);
})();
''' % (include_rule_string, exclude_rule_string)

	os_file_handle, \
	script_path = tempfile.mkstemp(prefix="surf_", dir="/tmp", text=True)
	file_handle = open(script_path, "w")
	file_handle.write(js)
	file_handle.close()

	atom_name = "_SURF_SCRIPT"
	command = "xprop -id %s -f %s 8s -set %s \"%s\"" \
		% (winid, atom_name, atom_name, script_path)
	os.system(command)
	# Give some time to execute the script.
	time.sleep(2)
	# Cleanup by removing the script.
	os.unlink(script_path)

if __name__ == '__main__':
	generate_javascript_adblocker(get_domain(argv[2]), argv[1])
