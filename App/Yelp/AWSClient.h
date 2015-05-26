//
//  AWSClient.h
//  Yelp
//
//  Created by Xu He on 4/18/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "AWSDynamoDBObjectMapper.h"
#import <AWSDynamoDB/AWSDynamoDB.h>
@interface AWSClient : AWSDynamoDBObjectModel

@property (nonatomic, strong) AWSDynamoDBObjectMapper *dynamoDBObjectMapper;

-(id) initCredentials;
-(BFTask *) getBasedOnKey:(NSString *)restKey;
-(BFTask *) setMenuBasedOnKey:(NSString *)restKey;

@end
