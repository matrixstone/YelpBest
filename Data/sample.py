# -*- coding: utf-8 -*-
"""
Yelp API v2.0 code sample.

This program demonstrates the capability of the Yelp API version 2.0
by using the Search API to query for businesses by a search term and location,
and the Business API to query additional information about the top result
from the search query.

Please refer to http://www.yelp.com/developers/documentation for the API documentation.

This program requires the Python oauth2 library, which you can install via:
`pip install -r requirements.txt`.

Sample usage of the program:
`python sample.py --term="bars" --location="San Francisco, CA"`
"""
import argparse
import json
import pprint
import sys
import urllib
import urllib2
import commands
import oauth2


API_HOST = 'api.yelp.com'
DEFAULT_TERM = 'restaurant'
DEFAULT_LOCATION = '94085'
SEARCH_LIMIT = 30
SEARCH_PATH = '/v2/search/'
BUSINESS_PATH = '/v2/business/'

# OAuth credential placeholders that must be filled in by users.
CONSUMER_KEY = "45fcmgyIjxMk-J-5GeTVjQ"
CONSUMER_SECRET = "qWFkA9aUJps0YSz1RMBaErlcDwY"
TOKEN = "jWc_WzCrqpdrMb4B1gx2N7lixEi6msNu"
TOKEN_SECRET = "5bi4id__4I8wst5mPvXCRdtGb8w"


def request(host, path, url_params=None):
    """Prepares OAuth authentication and sends the request to the API.

    Args:
        host (str): The domain host of the API.
        path (str): The path of the API after the domain.
        url_params (dict): An optional set of query parameters in the request.

    Returns:
        dict: The JSON response from the request.

    Raises:
        urllib2.HTTPError: An error occurs from the HTTP request.
    """
    url_params = url_params or {}
    url = 'http://{0}{1}?'.format(host, urllib.quote(path.encode('utf8')))

    consumer = oauth2.Consumer(CONSUMER_KEY, CONSUMER_SECRET)
    oauth_request = oauth2.Request(method="GET", url=url, parameters=url_params)
    oauth_request.update(
        {
            'oauth_nonce': oauth2.generate_nonce(),
            'oauth_timestamp': oauth2.generate_timestamp(),
            'oauth_token': TOKEN,
            'oauth_consumer_key': CONSUMER_KEY
        }
    )
    token = oauth2.Token(TOKEN, TOKEN_SECRET)
    oauth_request.sign_request(oauth2.SignatureMethod_HMAC_SHA1(), consumer, token)
    signed_url = oauth_request.to_url()
    
    # print u'Querying {0} ...'.format(signed_url)

    conn = urllib2.urlopen(signed_url, None)
    try:
        response = json.loads(conn.read())
    finally:
        conn.close()

    return response

def search(term, location):
    """Query the Search API by a search term and location.

    Args:
        term (str): The search term passed to the API.
        location (str): The search location passed to the API.

    Returns:
        dict: The JSON response from the request.
    """
    
    url_params = {
        'term': term.replace(' ', '+'),
        'location': location.replace(' ', '+')
        # 'limit': SEARCH_LIMIT
    }
    return request(API_HOST, SEARCH_PATH, url_params=url_params)

def get_business(business_id):
    """Query the Business API by a business ID.

    Args:
        business_id (str): The ID of the business to query.

    Returns:
        dict: The JSON response from the request.
    """
    business_path = BUSINESS_PATH + business_id

    return request(API_HOST,  business_path)

def query_api(term, location, outputName):
    """Queries the API by the input values from the user.

    Args:
        term (str): The search term to query.
        location (str): The location of the business to query.
    """
    response = search(term, location)

    (status, timestamp) = commands.getstatusoutput("date +\"%Y-%m-%d-%H-%M\"")
    searchResult=open(outputName, "w")
    searchResult.write(json.dumps(response))
    searchResult.close()

    businesses = response.get('businesses')

    if not businesses:
        print u'No businesses for {0} in {1} found.'.format(term, location)
        return

    # business_id = 

    # print u'{0} businesses found, querying business info for the top result "{1}" ...'.format(
    #     len(businesses),
    #     business_id
    # )
    idList=[]
    for business in businesses:
        business_id = business['id']
        idList.append(business_id)
        # response = get_business(business_id)
        # businessResult=open("%s-%s.json" % (business_id, timestamp), "a")
        # businessResult.write(json.dumps(response))
        # businessResult.close()

    idListResult=open("idlist.txt", "a")
    for eachID in idList:
        print eachID
        idListResult.write(eachID+"\tfalse"+"\n")
    idListResult.close()
    # print u'Result for business "{0}" found:'.format(business_id)
    # pprint.pprint(response, indent=2)


def main():
    ziplistfile=open
    outputfilename=""
    currentZip=""
    term=""
    zipFile=open("zipList.txt", "r")
    linesInZipFile=zipFile.readlines()
    zipFile.close()
    zipFile=open("zipList.txt", "w")
    for line in linesInZipFile:
        words=line.strip().split("\t")
        # print words[2]
        if len(words) < 2:
            term=words[0]
            zipFile.write(line)
        elif words[2] == "false":
            outputfilename=words[0]+"_"+words[1]
            outputfilename="restaurant data/"+term+"_"+outputfilename+".json"
            currentZip= words[1]
            print outputfilename
            print currentZip
            parser = argparse.ArgumentParser()

            parser.add_argument('-q', '--term', dest='term', default=DEFAULT_TERM, type=str, help='Search term (default: %(default)s)')
            parser.add_argument('-l', '--location', dest='location', default=currentZip, type=str, help='Search location (default: %(default)s)')

            input_values = parser.parse_args()

            try:
                query_api(input_values.term, input_values.location, outputfilename)
            except urllib2.HTTPError as error:
                sys.exit('Encountered HTTP error {0}. Abort program.'.format(error.code))
            zipFile.write(words[0]+"\t"+words[1]+"\ttrue\n")
        elif words[2] == "true":
            zipFile.write(line)

    # with open("zipList.txt", "r") as ins:
    #     for line in ins:
    #         words=line.strip().split("\t")
    #         # print words[2]
    #         if len(words) < 2:
    #             term=words[0]
    #         elif words[2] == "false":
    #             outputfilename=words[0]+"_"+words[1]
    #             outputfilename="restaurant data/"+term+"_"+outputfilename+".json"
    #             currentZip= words[1]
    #             parser = argparse.ArgumentParser()

    #             parser.add_argument('-q', '--term', dest='term', default=DEFAULT_TERM, type=str, help='Search term (default: %(default)s)')
    #             parser.add_argument('-l', '--location', dest='location', default=currentZip, type=str, help='Search location (default: %(default)s)')

    #             input_values = parser.parse_args()

    #             try:
    #                 query_api(input_values.term, input_values.location, outputfilename)
    #             except urllib2.HTTPError as error:
    #                 sys.exit('Encountered HTTP error {0}. Abort program.'.format(error.code))

def secondMain():
    # print urllib.quote_plus("cafe-zoë-menlo-park-2")
    path="cafe-zoë-menlo-park-2"
    response = get_business("cafe-zoë-menlo-park-2")
    print response


if __name__ == '__main__':
    reload(sys)
    sys.setdefaultencoding("utf-8")
    # secondMain()
    main()