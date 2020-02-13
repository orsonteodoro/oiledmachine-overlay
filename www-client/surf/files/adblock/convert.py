#!/usr/bin/env python
# Converts adblock lists to a format usable for surfAdblock

from __future__ import print_function
import re
import sys

socketblock = []
exceptions = []
allitems = {}
#if len(sys.argv) <= 1:
#	print('%s <filename>' % (sys.argv[0]))
#	exit(1)

#filename = sys.argv[1]
#lines = file(filename, 'r').readlines()

lines = sys.stdin.readlines()

for line in lines:
	line = line.strip()
	if line.startswith('!'):
		continue

	if line.count("\'") + line.count("\"") % 2 != 0:
		continue

	if line.find('[Adblock') > -1:
		continue

	#line     = re.sub('^@@', '', line)
	#line     = re.sub('^\|\|', '', line)
	#line     = re.sub('^[Adblock.*]', '', line)

	line     = line.replace("\\", "\\\\").strip()

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

		# Try to extract the selector in some other format.
		if not selector:
			selector = line
			selector = re.sub('\$[~]?[a-z_\-]+.*', '', selector)
			selector = re.sub('\*|\^', '', selector)
			if len(selector) <= 4:
				continue;
			selector = "img[src*='%s'],iframe[src*='%s']" % (selector, selector)
			#selector = "[src*='%s'],[href*='%s']" % (selector, selector)
		if selector:
			for site in sites:
				site = site.strip()
				#site = re.sub('^~', '', site)
				if site not in allitems:
					allitems[site] = []
				allitems[site].append(selector)
	elif line.startswith('@@') == True:
		line = re.sub('^@@', '', line)
		exceptions.append(line)
	else:
		socketblock.append(line);

ordered = sorted(allitems.keys())
for k in ordered:
	v = allitems[k]
	print('%s\n\t%s\n' % (k, '\n\t'.join(v)))

print('socketblock:')
ordered = sorted(socketblock)
for k in ordered:
	print('\t%s' % (k))
print('')

print('exceptions:')
ordered = sorted(exceptions)
for k in ordered:
	print('\t%s' % (k))
print('')
