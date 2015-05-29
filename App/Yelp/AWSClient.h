//
//  AWSClient.h
//  Yelp
//
//  Created by Xu He on 4/18/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "AWSDynamoDBObjectMapper.h"
//#import <AWSDynamoDB/AWSDynamoDB.h>
@interface AWSClient : AWSDynamoDBObjectModel

@property (nonatomic, strong) AWSDynamoDBObjectMapper *dynamoDBObjectMapper;
@property (nonatomic, strong) NSString *RestaurantID;

-(id) initCredentials;
-(BFTask *) getBasedOnKey:(NSString *)restKey;
-(BFTask *) setMenuBasedOnKey:(NSDictionary *)menuDict;

@end
