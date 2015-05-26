//
//  AWSClient.m
//  Yelp
//
//  Created by Xu He on 4/18/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "AWSClient.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import <AWSDynamoDB/AWSDynamoDB.h>
#import <AWSSQS/AWSSQS.h>
#import <AWSSNS/AWSSNS.h>
#import <AWSCognito/AWSCognito.h>

@implementation AWSClient

-(id) initCredentials{
    self=[super init];
    if(self){
        AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1 identityPoolId:@"us-east-1:d1a157f3-9918-46f7-a807-17975919ee49"];
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
        AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    }
        self.dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    return self;
}

-(BFTask *) getBasedOnKey:(NSString *)restKey{
    return [[self.dynamoDBObjectMapper load:[AWSClient class] hashKey:restKey rangeKey:nil]
     continueWithBlock:^id(BFTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error: [%@]", task.error);
         }
         if (task.exception) {
             NSLog(@"The request failed. Exception: [%@]", task.exception);
         }
         if (task.result) {
             NSMutableDictionary *restInfo = task.result;
//log
//             NSLog(@"Successfully load inside book: %@", restInfo);
//             for (NSString *key in restInfo) {
//                 NSLog(@"Each key is %@", key);
//                 NSLog(@"Each value is %@", [restInfo objectForKey:key]);
//             }
 
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:@"menuDict" object:task];

         return task;
     }];

}

//-(BFTask *) setMenuBasedOnKey:(NSString *)restKey{
//    
//}


+ (NSString *)dynamoDBTableName {
    return @"RestaurantTable";
}

+ (NSString *)hashKeyAttribute {
    return @"RestaurantID";
}


@end
