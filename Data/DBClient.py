from pymongo import MongoClient
import json
from bson.json_util import dumps
from bson.objectid import ObjectId
# client = MongoClient()
# db = client.test_database
# collection = db.test_collection
# print collection.find_one()


class DBClient:
	client=None
	databaseName="TrendingYelp"
	collectionName="TrendingYelp"
	collection=None
	documentID="550d13316f0ff3660bc6fab2"
	def __init__(self, cName=collectionName):
		client = MongoClient('localhost', 27017)
		db = client[self.databaseName]
		self.collection = db[cName]

	def get(self):
		return self.collection.find_one()
		# return self.collection.find({ '_id': ObjectId('550d13316f0ff3660bc6fab2') })
		# return self.collection.find({ "_id": "550d13316f0ff3660bc6fab2" })

	def put(self, content):
		jsonData=json.loads(content)
		dataID=self.collection.insert(jsonData)
		return dataID

	def update(self, key, value):
		# self.collection.find({name:{'$exists': 1}})[0]
		self.collection.update({ "_id": ObjectId(self.documentID) }, { "$set": { key: value } }, upsert=False)
		# content=self.get(resturant)
		# # content=content.replace("")
		# # print content
		# jsonData=json.loads(dumps(content))
		# jsonArray=jsonData[resturant]
		# for dic in jsonArray:
		# 	if dic["name"] == dish:
		# 		dic[up]=value
		# dataID=self.collection.update({resturant:{'$exists': 1}}, {'$set':{resturant: jsonData[resturant]}},upsert=False, multi=False)
		# dataID=0
		# return dataID


if __name__ == '__main__':

	client=DBClient()
	client.update("clinton-gourmet-clinton", "crab rangoon", "down", "1111")
	# #test for put
	# testJson=open("../jsonSample.json", 'r')
	# content=testJson.readlines()[0]
	# # print content
	# print client.put(content)

	# test for get
	# print client.get("clinton-gourmet-clinton")
	{"clinton-gourmet-clinton":{'$exists': 1}, "name":"crab rangoon"}