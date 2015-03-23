import sys, os, urllib2, time
from DBClient import DBClient as DB


FILENAME="idlist.txt"
BASE_URL="http://www.yelp.com/biz/"
def main():
	dbclient=DB("restaurantDownload")

	# try:
	# 	idfile=open(FILENAME, "r")
	# except IOError, em:
	# 	print >> sys.stderr, "Failed to find the file"
	# idList=idfile.readlines()
	# for idLine in idList:
	# 	restID=idLine.strip().split("\t")[0]
	# 	dbclient.update(restID, "false")

	cursor=dbclient.get()
	for restID, value in cursor.iteritems():
		if str(value) == "false":
			#dump html
			print "Dumping :"+str(restID)
			finalURL=BASE_URL+str(restID)
			try:
			    conn = urllib2.urlopen(finalURL, None)
			except urllib2.HTTPError as error:
				sys.exit('Encountered HTTP error {0}. Abort program.'.
					format(error.code))
			content=conn.read()
			#write to local
			businessOutput=open("restaurant business data/"+str(restID)+".html", "w")
			businessOutput.write(content)
			businessOutput.close()
			#update mongodb
			dbclient.update(restID, "true")
			time.sleep(20)

	# print cursor["alexanders-steakhouse-cupertino"]
	# print cursor.count()
	# dbclient.update("alexanders-steakhouse-cupertino", "true")
	# for record in cursor:
	# 	print record
	# print cursor.collection()
	# obj = next(cursor, None)
	# if obj:
	# 	age = obj["alexanders-steakhouse-cupertino"]
	# 	print age
	# entries = cursor[:]
	# for value in entries:
	# 	print value


	# idList=idfile.readlines()
	# for idLine in idList:
	# 	tag=idLine.strip().split("\t")[1]
	# 	if tag == 0:
	# 		#Do fetch html
	# 		finalURL=BASE_URL+tag[0]
	# 		try:
	# 		    conn = urllib2.urlopen(finalURL, None)
	# 		except urllib2.HTTPError as error:
	# 			sys.exit('Encountered HTTP error {0}. Abort program.'.
	# 				format(error.code))
	# 		content=conn.read()
			# restaurantFile=open(tag[0]+".html", "w")
			# restaurantFile.write(content)
			# restaurantFile.close()


if __name__ == '__main__':
	reload(sys)
	sys.setdefaultencoding("utf-8")
	main()