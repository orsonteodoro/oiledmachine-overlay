#!/usr/bin/env python
import sys
import os
import time
from sys import argv
from urlparse import urlparse
#import re
import re2 as re
from string_matching import *
import json
import time

# Blockfile location.
ADBLOCKFILE = os.path.dirname(argv[0]) + "/adblock"

def fresult(a):
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

def permit(url, urlmp): #url is the element, urlmp is the main page that holds the element
	st = time.time()
	v = url
	if v.startswith('https'):
		v = v.replace('https://','')
	elif v.startswith('http'):
		v = v.replace('http://','')
	if v.find('/') > -1:
		v = v.split('/')[0]
	if v.find('^') > -1:
		v = v.split('^')[0]
	t = v
	t = t.replace('www.','')

	url = url.strip()
	fh = open(ADBLOCKFILE, 'r')
	lines = [line for line in fh]
	fh.close()

	allow = -1

	mode = 'unknown'
	capture = False

	#0m0.047s

	d = {}
	dg = []
	if os.path.isfile('block1.dat') and os.path.isfile('block2.dat'):
		f = open('block1.dat','r')
		c = f.read()
		f.close()
		d = json.loads(c)

		f = open('block2.dat','r')
		c = f.read()
		f.close()
		dg = json.loads(c)
		print 'fast load'
	else:
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

	#0m0.382s
	mode = 'unknown'
	capture = False
	for l in dg:
		socketblock = False
		if l.startswith('@'):
			socketblock = True
			l = l[1:]
		result = False
		sc = []
		a = l.split('$')
		u = a[0]
		u = u.replace('|','')
		sc = u.split("*")
		l = len(sc)
		c = 0
		for s in sc:
			if len(s) == 0:
				continue
			#more info http://adblockplus.org/blog/investigating-filter-matching-algorithms
			s = s.replace('^','')
			s1 = s.replace("(","\(").replace(")","\)").replace("[","\[").replace("]","\]").replace("?","\?").replace("+","\+").replace(".","[.]")
			#0m0.427s without search
			try:
				r = string_matching_naive(url, s) #0m0.404s
				#r = string_matching_boyer_moore_horspool(url, s) #0m0.409s #broken on empty pattern strings
				#r = string_matching_knuth_morris_pratt(url, s) #0m0.609s
				#r = re.search(s1, url, re.I) #0m0.450s #python re
				#r = re.search(s1, url, re.I) #0m0.457s #google re2
				#r = string_matching_rabin_karp(url, s) #0m2.001s
			except:
				print 'err'
				continue

			if r: #for python re
			#if len(r) > 0: #for string_matching
				c+=1
			if c==l:
				result = True
			if result:
				fresult(a)
				if socketblock == True:
					print "blocked"
					if allow != 1:
						allow = 0
				else:
					print "pass"
					allow = 1

	if t in d:
		result = False
		for r in d[t]:
			socketblock = False
			if r.startswith('@'):
				socketblock = True
				r = r[1:]
			a = r.split('$')
			u = a[0]
			u = u.replace('|','')
			sc = u.split("*")
			l = len(sc)
			c = 0
			for s in sc:
				if len(s) == 0:
					continue
				#more info http://adblockplus.org/blog/investigating-filter-matching-algorithms
				s = s.replace('^','')
				s1 = s.replace("(","\(").replace(")","\)").replace("[","\[").replace("]","\]").replace("?","\?").replace("+","\+").replace(".","[.]")
				#0m0.427s without search
				try:
					r = string_matching_naive(url, s) #0m0.404s
					#r = string_matching_boyer_moore_horspool(url, s) #0m0.409s #broken on empty pattern strings
					#r = string_matching_knuth_morris_pratt(url, s) #0m0.609s
					#r = re.search(s1, url, re.I) #0m0.450s #python re
					#r = re.search(s1, url, re.I) #0m0.457s #google re2
					#r = string_matching_rabin_karp(url, s) #0m2.001s
				except:
					print 'err'
					continue

				if r: #for python re
				#if len(r) > 0: #for string_matching
					c+=1
				if c==l:
					result = True
				if result:
					fresult(a)
					if socketblock == True:
						print "blocked"
						if allow != 1:
							allow = 0
					else:
						print "pass"
						allow = 1

	if allow == -1:
		allow = 1


	print "allow="+str(allow)
	print("--- %s seconds ---" % (time.time() - st))
	sys.exit(allow)

if __name__ == '__main__':
	permit(argv[1], argv[2]) #1=element in main page, 2=main page
