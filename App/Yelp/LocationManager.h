//
//  LocationManager.h
//  Yelp
//
//  Created by Xu He on 3/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationManager : NSObject

@property (nonatomic, strong) CLLocationManager *locationManager;

+(LocationManager *) instance;

-(void)addLocationObserver:(id)observer block:(void (^)(NSNotification *note))block ;
@end
