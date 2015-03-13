//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"
#import "LocationManager.h"

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    __block CLLocation *location;
    [[LocationManager instance] addLocationObserver:self block:^(NSNotification *note) {
        
                 location = note.userInfo[@"location"];
//                NSLog(@"vc: location : %@", location);
        
//                MKCoordinateRegion coorRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
//                [self.mapView setRegion:coorRegion animated:YES];
            }];

    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
//    NSDictionary *parameters = @{@"term": @"steak", @"ll" : [[[[NSNumber numberWithDouble:location.coordinate.latitude] stringValue] stringByAppendingString:@","] stringByAppendingString:[[NSNumber numberWithDouble:location.coordinate.longitude] stringValue]],  @"limit" : @"20",  @"sort" : @"1"};
    
    NSDictionary *parameters = @{@"term": @"steak", @"ll" : @"37.793765, -122.404910",  @"limit" : @"20",  @"sort" : @"1"};
//    NSDictionary *parameters = @{@"term": @"restaurant", @"ll" : @"37.394531, -122.078344"};
//    NSDictionary *parameters = @{@"term": @"chinese restaurant", @"ll" : @"37.323175, -122.018882"};
//    NSDictionary *parameters = @{@"term": @"restaurant", @"ll" : @"37.792623, -122.420055"};
//    NSDictionary *parameters = @{@"term": @"restaurant", @"ll" : @"37.806864, -122.414442"};
    NSMutableDictionary *allParameters = [parameters mutableCopy];
    if (params) {
        [allParameters addEntriesFromDictionary:params];
    }
    
    return [self GET:@"search" parameters:allParameters success:success failure:failure];
}

@end
