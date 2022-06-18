#!/usr/bin/env python
# -*- coding: utf-8 -*-
import urllib2
import time
 
opener = urllib2.build_opener()
opener.addheaders = [('User-agent', 'Mozilla/5.0')]
file = open('addr.txt')
lines = file.readlines()
aa=[]
print('--------------------------开始第一次检查--------------------------')
for line in lines:
	if line.find('http')!=(-1):
		index=line.index('http')
		url=line[index:].replace('\n','')
		try:
			code=urllib2.urlopen(url).getcode()
			print(url+'\tstatus code is: '+bytes(code))
		except urllib2.URLError:
			print(url+'\tURLError无法访问 ')
		except urllib2.HTTPError:
			print(url+'\tHTTPError无法访问 ')
	else:
		continue
	
	aa.append(url)
 
time.sleep(2)
 
print('--------------------------开始第二次检查--------------------------')
for a in aa:
	tempUrl = a
	try :
		opener.open(tempUrl)
		print(tempUrl+'\t没问题')
	except urllib2.HTTPError:
		print(tempUrl+'\tHTTPError访问页面出错')
		time.sleep(2)
	except urllib2.URLError:
		print(tempUrl+'\tURLError访问页面出错')
		time.sleep(2)
	time.sleep(0.1)
