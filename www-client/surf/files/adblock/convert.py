#!/usr/bin/env python
# Converts the adblock lists to a format usable for adblock.py

from __future__ import print_function
import re
import sys

def convert_blocklist(lines):
	'''
	Prepares the block lists to be used by the ad blocker.

	It outputs to stdout the ruleset without the _1 ... _N suffixes in

	domain_1
		css selector

	domain_2
		css selector
		css selector
		css selector
		css selector

	...

	global
		css selector
		css selector
		css selector
		css selector
		css selector
		css selector

	...

	domain_N
		css selector
		css selector
		css selector
		css selector

	The  domain_1 ... domain_N  contain specific domain rules.

	The  global set  applies to all domains.

	The  socketblock set  contains resources that should be blocked at
	the socket level.

	The  exception set  contains elements that should not be blocked.

	Parameters
	----------
	lines : str
		A list of rules provided by a blocklist service

	Returns
	-------
		None
	'''
	socket_block = []
	exceptions = []
	all_items = {}

	for line in lines:
		line = line.strip()
		if line.startswith('!'):
			continue

		if line.count("\'") + line.count("\"") % 2 != 0:
			continue

		if line.find('[Adblock') > -1:
			continue

		line = line.replace("\\", "\\\\").strip()

		exception = False
		if line.find('#@#') > -1:
			exception = True
			line = line.replace('#@#','##')
			line = "~" + line
		if line.find('##') > -1:
			splline  = line.split('##')
			sites    = splline[0]
			selector = ''.join(splline[1:])

			if sites and selector:
				sites = sites.split(',')
			else:
				sites = ['global']

			if not selector:
				selector = line
				selector = re.sub('\$[~]?[a-z_\-]+.*', '', \
						selector)
				selector = re.sub('\*|\^', '', selector)
				if len(selector) <= 4:
					continue;
				selector = "img[src*='%s'],iframe[src*='%s']" \
						% (selector, selector)
			if selector:
				for site in sites:
					site = site.strip()
					if site not in all_items:
						all_items[site] = []
					all_items[site].append(selector)
		elif line.startswith('@@') == True:
			line = re.sub('^@@', '', line)
			exceptions.append(line)
		else:
			socket_block.append(line);

	ordered_all_items = sorted(all_items.keys())
	for ordered_item in ordered_all_items:
		item = all_items[ordered_item]
		print('%s\n\t%s\n' % (ordered_item, '\n\t'.join(item)))

	print('socketblock')
	ordered_socket_block = sorted(socket_block)
	for socket_block in ordered_socket_block:
		print('\t%s' % (socket_block))
	print('')

	print('exceptions')
	ordered_exceptions = sorted(exceptions)
	for exception in ordered_exceptions:
		print('\t%s' % (exception))
	print('')

if __name__ == '__main__':
	lines = sys.stdin.readlines()
	convert_blocklist(lines)
