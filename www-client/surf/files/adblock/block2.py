#!/usr/bin/env python
import sys
import os
import time
import re
from sys import argv
from urlparse import urlparse
#import re2 as re

# Blockfile location.
ADBLOCKFILE = os.path.dirname(argv[0]) + "/adblock"

def permit(url, urlmp): #url is the element, urlmp is the main page that holds the element

	#print url
	t = url.split('//')[1].split('/')[0].split('?')[0].split(':')[0].replace('www.','')
	#print t

	tm = urlmp.split('//')[1].split('/')[0].split('?')[0].split(':')[0].replace('www.','')
	#print tm

	url = url.strip()
	fh = open(ADBLOCKFILE, 'r')
	lines = [line for line in fh]
	fh.close()

	allow = 1

	#for l in lines:
	#	pass
	#sys.exit(1)

	mode = 'unknown'
	capture = False
	for l in lines:
		if l.strip().find("exceptions") != -1:
			mode = 'exceptions'
			capture = True
		elif l.strip().find("socketblock") != -1:
			mode = 'socketblock'
			capture = True
		elif len(l.strip()) == 0:
			capture = False
		elif capture == True:
			p = l.strip()

			p = p.replace("(","\(")
			p = p.replace(")","\)")

			h = False
			dom = False
			sw = False
			if p.startswith('||') == True:
#				p = '(http://|https://|http://www.|https://www.)'+l.strip()[2:]
				p = l.strip()[2:]
				h = True
				dom = True
			elif p.startswith('|') == True:
				p = p.strip()[1:]
				h = True
				sw = True
			a = p.split('$')

			p = a[0].strip()
			if p.endswith('|') == True:
				p = p[:-1]

			if p.find('|') > -1: #speed up ignore
				continue

			v = p
			if v.startswith('http'):
				v = p.replace('http://','')
			elif p.startswith('https'):
				v = p.replace('https://','')
			if v.find('/') > -1:
				v = v.split('/')[0]
			if v.find('^') > -1:
				v = v.split('^')[0]


			if h == True and t == v:
				pass
			elif h == True:
				continue
			else:
				pass

			p = p.replace("[","\[").replace("]","\]").replace("?","\?").replace("+","\+").replace(".","[.]")
			if p.find('*') > -1:
				p = p.replace("*","(.*)")
			if p.find('^') > -1:
				p = p.replace("^","[?/]?")

			try:
				if dom == True:
					p = '(http[s]?://(www.)?)'+p
				result = re.search(p, url, re.I) #slowest part
				#result = False
			except:
				pass
			else:
				if result:
					#print("\npattern:"+p)
					if len(a) > 1:
						opts = a[1].split(',')
						for i in opts:
							excludeopt = False
							if i.startswith('~'):
								#print 'excludeopt'
								excludeopt = True
								i = i[1:]
							if i == 'third-party':
								#print "third-party"
								pass
							elif i == 'script':
								#print "script"
								pass
							elif i == 'image':
								#print "image"
								pass
							elif i == 'stylesheet':
								#print "stylesheet"
								pass
							elif i == 'object':
								#print "object"
								pass
							elif i == 'xmlhttprequest':
								#print "xmlhttprequest"
								pass
							elif i == 'object-subrequest':
								#print "object-subrequest"
								pass
							elif i == 'subdocument':
								#print "subdocument"
								pass
							elif i == 'document':
								#print "document"
								pass
							elif i == 'elemhide':
								#print "elemhide"
								pass
							elif i == 'other':
								#print "other"
								pass
							elif i == 'popup':
								#print "popup"
								pass
							elif i == 'collapse':
								#print "collapse"
								pass
							elif i.find('domain') > -1:
								domains = i.split('=')[1].split('|')
								#print "domain"
								for d in domains:
									d = d.replace("\\","")
									if d.startswith('~') == True: #exception
										d = d[1:]
									#print d
					if mode == 'socketblock':
						allow = 0
					else:
						allow = 1

	sys.exit(allow)

if __name__ == '__main__':
	permit(argv[1], argv[2]) #1=element in main page, 2=main page
