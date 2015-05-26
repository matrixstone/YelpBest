//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"


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

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term params:(NSDictionary *)params locationSelect:(NSInteger) locationIndex success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    __block CLLocation *location;
    if (!term.length) {
        term=@"Restaurants";
    }
    
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        
        [[LocationManager instance] addLocationObserver:self block:^(NSNotification *note) {
            
                        location = note.userInfo[@"location"];
//                        NSLog(@"vc: location : %@", location);
//                        NSLog(@"location variables : %+.6f, %+.6f", location.coordinate.latitude,location.coordinate.longitude);
            
//                    dispatch_semaphore_signal(semaphore);
        }];

//    NSLog(@"Test3333: %@", [LocationManager instance].location);
    LocationManager *localManager=[LocationManager instance];
    NSDictionary *parameters =[[NSDictionary alloc]init];
    NSLog(@"coordinate %@", localManager.location);

    if (localManager.location.coordinate.latitude == 0.0 && localManager.location.coordinate.longitude == 0.0) {
        NSLog(@"latitude %+.6f, %+.6f", location.coordinate.latitude,location.coordinate.longitude);
        parameters = @{@"term": term, @"ll" : @"37.774866,-122.394556"};
    }else{
        NSLog(@"latitude not nil %+.6f, %+.6f", localManager.location.coordinate.latitude,localManager.location.coordinate.longitude);
        NSString *ll=[NSString stringWithFormat:@"%+.6f, %+.6f",localManager.location.coordinate.latitude, localManager.location.coordinate.longitude];
        parameters = @{@"term": term, @"ll":ll };
    }
                    
    

    NSMutableDictionary *allParameters = [parameters mutableCopy];
    if (params) {
        [allParameters addEntriesFromDictionary:params];
    }

    
//    NSLog(@"Test for log");
//    [[LocationManager instance] locationManager:[LocationManager instance] didUpdateLocations]
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
//    NSDictionary *parameters = @{@"term": @"steak", @"ll" : [[[[NSNumber numberWithDouble:location.coordinate.latitude] stringValue] stringByAppendingString:@","] stringByAppendingString:[[NSNumber numberWithDouble:location.coordinate.longitude] stringValue]],  @"limit" : @"20",  @"sort" : @"1"};
//    NSLog(@"Index Num:%d", locationIndex);
//    NSDictionary *parameters = @{@"term": @"steak", @"ll" : @"37.793765, -122.404910",  @"limit" : @"20",  @"sort" : @"1"};
//    if(locationIndex == 0){
//        parameters = @{@"term": @"steak", @"ll" : @"37.793765, -122.404910",  @"limit" : @"20",  @"sort" : @"1"};
//    }else if (locationIndex == 1){
//        parameters = @{@"term": @"restaurant", @"ll" : @"37.394531, -122.078344"};
//    }
    
//    }else if (locationIndex == 2){
//        parameters = @{@"term": @"chinese restaurant", @"ll" : @"37.323175, -122.018882"};
//    }else if (locationIndex == 3){
//        parameters = @{@"term": @"restaurant", @"ll" : @"37.792623, -122.420055"};
//    }

  return [self GET:@"search" parameters:allParameters success:success failure:failure];
//
//
//    NSDictionary *parameters = @{@"term": @"restaurant", @"ll" : @"37.806864, -122.414442"};

}

-(CLLocation *)getLocation:(NSNotification *)notify{
    return [notify object];
}

@end
