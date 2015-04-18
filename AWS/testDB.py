import boto.dynamodb
conn = boto.dynamodb.connect_to_region(
        'us-east-1',
        aws_access_key_id='AKIAJ7QHWVID6OP6FZCQ',
        aws_secret_access_key='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')
# list table: conn.list_tables()
message_table_schema = conn.create_schema(
        hash_key_name='Books',
        hash_key_proto_value=str
    )
table = conn.create_table(
        name='Books',
        schema=message_table_schema,
        read_units=2,
        write_units=2
    )
# get table:
# table = conn.get_table('pythonTestTable')

conn.describe_table('pythonTestTable')

table = conn.table_from_schema(
    name='pythonTestTable',
    schema=message_table_schema)

table = conn.get_table('pythonTestTable')

item_data = {
	'mason-pacific-san-francisco': 
	[{'down': 0, 'review': '26', 'name': 'potato skin', 'up': 0}, 
	{'down': 0, 'review': '25', 'name': 'pretzel bun', 'up': 0}, 
	{'down': 0, 'review': '19', 'name': 'crispy feta', 'up': 0}, 
	{'down': 0, 'review': '10', 'name': 'chocolate pot', 'up': 0}, 
	{'down': 0, 'review': '9', 'name': 'green bean', 'up': 0}, 
	{'down': 0, 'review': '8', 'name': 'beet salad', 'up': 0}, 
	{'down': 0, 'review': '8', 'name': 'ice cream', 'up': 0}, 
	{'down': 0, 'review': '7', 'name': 'grilled octopu', 'up': 0}, 
	{'down': 0, 'review': '7', 'name': 'white cheddar', 'up': 0}, 
	{'down': 0, 'review': '7', 'name': 'duck confit', 'up': 0}]
	}

item_data = {
"id" : 101
}

item_data = "{\
        \"Body\": [\"aaaaa\", \"bbbbb\"],\
        'SentBy': 'User A',\
        'ReceivedTime': '12/9/2011 11:36:03 PM',\
    }"

item_data = {
        'pythonTestTable': 123,
        'Body': set([]),
        'SentBy': '{"key":"value"}',
        'ReceivedTime': '12/9/2011 11:36:03 PM',
    }

item_data = {
        'Body': 'aaaaa',
        'SentBy': collections.Counter({'blue': 3, 'red': 2, 'green': 1}),
        'ReceivedTime': '12/9/2011 11:36:03 PM',
    }


item_data={}
item_data['Body']="aaaaa"
level2=[]
level2.append("bbbbb")
item_data["testList"]=level2

item_data = { 
Id = 101,                 
ProductName = "Book 101 Title"
} 

item = table.new_item(
        hash_key='testKey',
        attrs=item_data
    )

item.put()



item_data={ 
   Id = 101                                       
   ProductName = "Book 101 Title"
   ISBN = "111-1111111111"
   Authors = [ "Author 1", "Author 2" ]
   Price = -2
   Dimensions = "8.5 x 11.0 x 0.5"
   PageCount = 500
   InPublication = 1
   ProductCategory = "Book" 
}    


from boto.dynamodb2.fields import HashKey
from boto.dynamodb2.table import Table
users = Table.create('users', schema=[HashKey('username')],
	throughput={
     'read': 5,
     'write': 15,
   });

item = table.get_item(hash_key='mason-pacific-san-francisco')
item = table.get_item(hash_key='6543210987')



