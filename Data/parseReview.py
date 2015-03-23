import sys, os, urllib2, time, urllib
from DBClient import DBClient as DB
import HTMLParser


FILENAME="restaurant business data/three-brothers-tacos-east-palo-alto-2.html"
BASE_URL="http://www.yelp.com/biz/"
def main():
	restaurantFile=open(FILENAME, "r")
	count=0
	html_parser = HTMLParser.HTMLParser()
	for line in restaurantFile.readlines():
		if "<p itemprop=\"description\" lang=\"en\">" in line:
			print html_parser.unescape(line)
			# .decode('utf8')
			count+=1
	print count


if __name__ == '__main__':
	reload(sys)
	sys.setdefaultencoding("utf-8")
	main()