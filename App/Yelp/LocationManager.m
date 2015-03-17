//
//  LocationManager.m
//  Yelp
//
//  Created by Xu He on 3/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()<CLLocationManagerDelegate>

@end

@implementation LocationManager

+(LocationManager *) instance{
    static LocationManager *locationManager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (locationManager == nil) {
            locationManager = [[LocationManager alloc]init];
            
        }
    });
    return locationManager;
}

-(id)init{
    self=[super init];
    if (self) {
       
        self.locationManager=[[CLLocationManager alloc]init];
        [self.locationManager requestAlwaysAuthorization];
        
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.delegate=self;
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations{
    CLLocation *location=locations[0];
//     NSLog(@"test inside location manager");
//    NSLog(@"location : %@", locations);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kLocationDidUpdate" object:nil userInfo:@{@"location":location}];
}

-(void)addLocationObserver:(id)observer block:(void (^)(NSNotification *note))block {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"kLocationDidUpdate" object:nil queue:[NSOperationQueue mainQueue] usingBlock:block];
}

@end
