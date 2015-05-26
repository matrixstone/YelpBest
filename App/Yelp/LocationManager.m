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
        self.location = [[CLLocation alloc] init];
        
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.delegate=self;
//        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations{
   CLLocation* location = [locations lastObject];
    self.location=location;
//     NSLog(@"test inside location manager");
//    NSLog(@"location : %@", locations);
//    
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 1.0) {
        // If the event is recent, do something with it.
//        NSLog(@"latitude %+.6f, longitude %+.6f\n",
//              location.coordinate.latitude,
//              location.coordinate.longitude);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kLocationDidUpdate" object:nil userInfo:@{@"location":location}];
//    }
    

}

-(void)addLocationObserver:(id)observer block:(void (^)(NSNotification *note))block {
//    dispatch_queue_t *queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
   [[NSNotificationCenter defaultCenter] addObserverForName:@"kLocationDidUpdate" object:nil queue:[NSOperationQueue currentQueue] usingBlock:block];
}

@end
