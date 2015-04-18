
import boto.dynamodb2
from boto.dynamodb2.fields import HashKey, RangeKey, KeysOnlyIndex, GlobalAllIndex
from boto.dynamodb2.table import Table
from boto.dynamodb2.types import NUMBER
import json, sys

aws_access_key_id='AKIAJ7QHWVID6OP6FZCQ'
aws_secret_access_key='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'
TABLE_NAME='RestaurantTable'

TABLE_KEY='RestaurantID'
TABLE_DISH_KEY='DishInfos'
INPUT_FILE='part1.json'

def putRecord(line, restTable):
	data={}
	try:
		jsonData=json.loads(line.replace("\'","\""))
	except Exception, em:
		print >> sys.stderr, "Json format error. Mes: %s" % str(em)
	# restID=jsonData.keys()[0]
	for restID, dishInfos in jsonData.iteritems():
		if restTable.has_item(RestaurantID=restID):
			print >> sys.stderr, "Skip RestaurantID: %s" % restID
			continue
		data[TABLE_KEY]=restID
		'''
		Json format:

		{'RestaurantID':'gaspar-brasserie-san-francisco',
		 'duck confit': '{'down': 0, 'review': '14', 'name': 'duck confit', 'up': 0}', 

		 {'down': 0, 'review': '6', 'name': 'salmon crepe', 'up': 0}, 
		 {'down': 0, 'review': '6', 'name': 'duck breast', 'up': 0}, 
		 {'down': 0, 'review': '4', 'name': 'chickpea cake', 'up': 0}
		 ]}

		'''
		for dishInfo in dishInfos:
			# dishDic={}
			data[dishInfo['name']]=str(dishInfo)
			# dishDic['down']=dishInfo['down']
			# dishDic['review']=dishInfo['review']
			# dishDic['name']=dishInfo['name']
			# dishDic['up']=dishInfo['up']
			# data[TABLE_DISH_KEY].add(dishDic)
	# print data
	#put item
	if restTable.put_item(data) == True:
		print "Successfully write: %s" % data[TABLE_KEY]

def main():
	restTable = Table(TABLE_NAME, schema=[HashKey(TABLE_KEY)])
	#get Item:
	# item = restTable.get_item(username='johndoe', last_name='Doe')
	try:
		inputFile=open(INPUT_FILE, 'r')
	except Exception, em:
		print >> sys.stderr, "File reading error. Mes: %s" % str(em)
	# line=inputFile.readline()
	for line in inputFile.readlines():
		try:
			putRecord(line, restTable)
		except Exception, em:
			print >> sys.stderr, "Error to line: %s" % line
			continue
	#get item
	# print restTable.has_item(RestaurantID='mason-pacific-san-francisco')

	#cehck all items:
	for rest in restTable.scan():
		print rest[TABLE_KEY]
	
	# conn = boto.dynamodb.connect_to_region(
 #        'us-east-1',
 #        aws_access_key_id,
 #        aws_secret_access_key)

	# table_schema = conn.create_schema(
 #        hash_key_name=TABLE_NAME,
 #        hash_key_proto_value=str
 #    )

 #    table = conn.table_from_schema(
	#     name=TABLE_NAME,
	#     schema=message_table_schema)

if __name__ == '__main__':
	main()