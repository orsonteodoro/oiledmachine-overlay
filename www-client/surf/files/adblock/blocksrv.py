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

def search(pattern, string):
    len_pat = len(pattern)
    len_str = len(string)
    i = 0
    while i < len_str:
        j = 0
        while j < len_pat and i+j < len_str and pattern[j] == string[i+j]:
            j += 1
        if j == len_pat:
            return i
        i += 1
    return -1


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

def prefilldata():
	global d
	global dg
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
		return True
	return True

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

def loaddata():
	if prefilldata():
		pass
	else:
		coldfilldata()

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

	allow = -1

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
		i = 0
		for s in sc:
			if len(s) == 0:
				continue
			#more info http://adblockplus.org/blog/investigating-filter-matching-algorithms
			s = s.replace('^','')
			#s1 = s.replace("(","\(").replace(")","\)").replace("[","\[").replace("]","\]").replace("?","\?").replace("+","\+").replace(".","[.]")
			#0m0.427s without search
			try:
				r = search(s, url)
				#r = string_matching_naive(url, s) #0m0.404s
				#	r = string_matching_boyer_moore_horspool(url, s) #0m0.409s #broken on empty pattern strings
				#r = string_matching_knuth_morris_pratt(url, s) #0m0.609s
				#r = re.search(s1, url, re.I) #0m0.450s #python re
				#r = re.search(s1, url, re.I) #0m0.457s #google re2
				#r = string_matching_rabin_karp(url, s) #0m2.001s
			except:
				print 'err'
				print sys.exc_info()
				continue

			#if r: #for python re
			#if len(r) > 0: #for string_matching
			if r > -1: #for string_matching
				c+=1
			if i > c:
				break
			i+=1
			if c>=l:
				result = True
			if result:
				fresult(a)
				if socketblock == True:
					#print "blocked"
					if allow != 1:
						allow = 0
				else:
					#print "pass"
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
			i = 0
			for s in sc:
				if len(s) == 0:
					continue
				#more info http://adblockplus.org/blog/investigating-filter-matching-algorithms
				s = s.replace('^','')
				#s1 = s.replace("(","\(").replace(")","\)").replace("[","\[").replace("]","\]").replace("?","\?").replace("+","\+").replace(".","[.]")
				#0m0.427s without search
				try:
					r = search(s, url)
					#r = string_matching_naive(url, s) #0m0.404s
					#	r = string_matching_boyer_moore_horspool(url, s) #0m0.409s #broken on empty pattern strings
					#r = string_matching_knuth_morris_pratt(url, s) #0m0.609s
					#r = re.search(s1, url, re.I) #0m0.450s #python re
					#r = re.search(s1, url, re.I) #0m0.457s #google re2
					#r = string_matching_rabin_karp(url, s) #0m2.001s
				except:
					print 'err'
					print sys.exc_info()
					continue

				#if r: #for python re
				#if len(r) > 0: #for string_matching
				if r > -1: #for string_matching
					c+=1
				if c>=l:
					result = True
				if i > c:
					break
				i+=1
				if result:
					fresult(a)
					if socketblock == True:
						#print "blocked"
						if allow != 1:
							allow = 0
					else:
						#print "pass"
						allow = 1

	if allow == -1:
		allow = 1

	print "allow="+str(allow)
	print("--- %s seconds ---" % (time.time() - st))
	return allow


def sighup(signum, frame):
	print 'hanging up'
	alive = False
	conn.close()
	listener.close()
	sys.exit(-1)

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
	for v in argv:
		if v == '-s':
			daemon = True
			pmode = 'server'
			loaddata()
		elif v == '-c':
			pmode = 'client'
		elif v.startswith('--eleurl='):
			eleurl = v[9:]
		elif v.startswith('--mpurl='):
			mpurl = v[8:]

	#client server design is to lower loading overhead time
	if pmode == 'server':
		f = open('adbserver.pid', 'w')
		try:
			fcntl.lockf(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
		except:
			print 'already running'
			sys.exit(-1)
		print 'starting server'
		signal.signal(signal.SIGHUP, sighup)
		signal.signal(signal.SIGINT, sighup)
		address = ('localhost', 6000)
		listener = Listener(address)
		while alive == True:
			try:
				conn = listener.accept()
			except:
				pass
			else:
				tconn = conn
				pid = os.fork()
				#print "pid="+str(pid)
				if pid == 0:
					data = tconn.recv()
					if len(data) > 0:
						result = permit(data[0],data[1])
						tconn.send(result)
					tconn.close()
					sys.exit(0)
		listener.close()
	elif pmode == 'client':
		address = ('localhost', 6000)
		conn = Client(address)
		conn.send([eleurl, mpurl])
		result = conn.recv()
		#print result
		conn.close()
		sys.exit(result)

