from bottle import route, run, request, response
from DBClient import DBClient
from bson.json_util import dumps
@route('/recipes/')
def recipes_list():
    return "LIST"

@route('/recipes/<name>', method='GET')
def recipe_show( name="Mystery Recipe" ):
    # return "SHOW RECIPE " + name
    client=DBClient()
    # print name
    response.content_type = 'application/json'
    return dumps(client.get(name))
    # return name

@route('/recipes/<name>', method='DELETE' )
def recipe_delete( name="Mystery Recipe" ):
    return "DELETE RECIPE " + name

@route('/recipes/<name>', method='PUT')
def recipe_save( name="Mystery Recipe" ):
	# curl -X PUT --data-urlencode "json=jsonSample.json" http://localhost:8080/recipes/marlowe
	path="/Users/haibow/Documents/MATLAB/YelpBest/"
	jsonName = request.forms.get( "json" )
	# print jsonName
	filepath=path+jsonName
	f=open(filepath, 'r')
	content=f.readlines()[0]
	# print content
	content=content.replace("\'", "\"");
	client=DBClient()
	resultID=client.put(content)
	return jsonName+" "+repr(resultID)

run(host='localhost', port=8080, debug=True)
