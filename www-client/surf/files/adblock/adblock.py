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
	lines_whitelist = [line.strip() for line in file_handle]
	file_handle.close()

	url = get_domain(url)
	rules_include = []
	rules_exclude = []
	exclude = False
	capture = False
	for line in lines_whitelist:
		if url.find(line) > -1:
			sys.exit()
	for line in lines_blockfile:
		is_not_selector = line[0] != '\t'
		line = line.strip()
		if is_not_selector and len(line) > 0:
			domain = None
			if line.startswith('~'):
				exclude = True
				domain = get_domain(line[1:])
				if domain == url:
					capture = True
			if get_domain(line) == url \
				or line == "global":
				capture = True
		elif not line:
			capture = False
			exclude = False
		elif capture:
			line = line.replace("'", "\\'")
			if exclude == False:
				rules_include.append(line)
			else:
				rules_exclude.append(line)
	exclude_rule_string = ','.join(rules_exclude)
	include_rule_string = ','.join(rules_include)

	js_include = '''
(function() {
	var styleInclude = document.createElement('style');
	styleInclude.innerHTML = '%s { display: none !important ; }';
	document.head.appendChild(styleInclude);
})();
''' % (include_rule_string)
	js_exclude = '''
(function() {
	var styleExclude = document.createElement('style');
	styleExclude.innerHTML =
		'%s { display: default !important ; }';
	document.head.appendChild(styleExclude);
})();
''' % (exclude_rule_string)

	os_file_handle, \
	script_path = tempfile.mkstemp(prefix="surf_", dir="/tmp", text=True)
	file_handle = open(script_path, "w")
	if len(include_rule_string):
		file_handle.write(js_include)
	if len(exclude_rule_string):
		file_handle.write(js_exclude)
	file_handle.close()

	atom_name = "_SURF_SCRIPT"
	command = "xprop -id %s -f %s 8s -set %s \"%s\"" \
		% (winid, atom_name, atom_name, script_path)
	os.system(command)
	# The parent process will delete file.

if __name__ == '__main__':
	generate_javascript_adblocker(get_domain(argv[2]), argv[1])
