from pymongo import MongoClient
import json
# client = MongoClient()
# db = client.test_database
# collection = db.test_collection
# print collection.find_one()


class DBClient:
	client=None
	databaseName="TrendingYelp"
	collectionName="TrendingYelp"
	collection=None
	def __init__(self):
		client = MongoClient('localhost', 27017)
		db = client[self.databaseName]
		self.collection = db[self.collectionName]

	def get(self, name):
		# print self.collection.find_one({"name": "%s" % name})
		print "DBClient "+name
		return self.collection.find_one({"name": "%s" % name})

	def put(self, content):
		jsonData=json.loads(content)
		dataID=self.collection.insert(jsonData)
		return dataID


if __name__ == '__main__':

	client=DBClient()
	#test for put
	testJson=open("../jsonSample.json", 'r')
	content=testJson.readlines()[0]
	# print content
	print client.put(content)

	#test for get
	# print client.get("test")