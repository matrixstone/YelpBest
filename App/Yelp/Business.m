 //
//  Business.m
//  Yelp
//
//  Created by Xu He on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"
#import "MenuClient.h"

@implementation Business

-(id) initWithDictionary: (NSDictionary *)dictionary{
    self=[super init];
    
    if(self){
//        NSLog(@"Printing dictionary: %@", dictionary);
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
//        NSLog(@"categories: %@", self.categories);
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        self.isClosed =[dictionary[@"is_closed"] integerValue];
        self.url=[dictionary valueForKey:@"url"];
        
        self.location=[dictionary valueForKey:@"location"];
        NSArray *street =[[dictionary valueForKey:@"location"] valueForKey:@"address"][0];
        NSString *neighborhood=[[dictionary valueForKey:@"location"] valueForKey:@"neighborhoods"][0];
        self.address=[NSString stringWithFormat:@"%@, %@", street , neighborhood];
        
//        
//        self.city = [dictionary valueForKeyPath:@"location.city"];
//        self.stateCode = [dictionary valueForKeyPath:@"location.state_code"];
//        
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingsImageUrl = dictionary[@"rating_img_url"];
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;

    }
    return self;
}

+ (NSArray *)businessWithDictionaries:(NSArray *)dictionaries{
    NSMutableArray *businesses=[[NSMutableArray alloc]init];
    NSLog(@"%d", dictionaries.count);
    for (NSDictionary *dictionary in dictionaries) {
         Business *business=nil;
//        __block finished = NO;
//        [Business existingFilter:dictionary block:^(NSNotification *note) {
//            NSLog(@"Here is ver interesting");
//            if ([note object] == nil) {
//               
//            }else{
//
                 business= [[Business alloc]initWithDictionary:dictionary];
                 NSLog(@"URL: %@", business.url);
//                NSLog(@"inside businesses id: %@", businesses.self);
//                NSLog(@"Size of inside businesses: %d", businesses.count);
//            }
//             finished = YES;
//            
//        }];
//        while (!finished) {
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//              NSLog(@"waiting");
//        }
        [businesses addObject:business];
        
    }
//    [NSThread sleepForTimeInterval:10.0];
//    while(businesses.count == 0) {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
//    }
//    NSLog(@"outside businesses id: %@", businesses.self);
    
        // wait 1 second for the task to finish (you are wasting time waiting here)
       
    
//    NSLog(@"Size of outside businesses: %d", businesses.count);
    return businesses;
}
//
+ (void)existingFilter:(NSDictionary *)businessDic block:(void (^)(NSNotification *note))block{
//    NSLog(@"dic: %@", );
    NSArray* urlArray =[businessDic[@"url"] componentsSeparatedByString:@"/"];
    NSString *key=[urlArray objectAtIndex: urlArray.count-1];
    MenuClient *mc=[[MenuClient alloc]init];
    [mc getMenu:key];
    NSLog(@"Test for time");
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkExistingOrNot:) name:@"menuJson" object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"menuJson" object:nil queue:[NSOperationQueue currentQueue] usingBlock:block];
    NSLog(@"Test for end");
//    [NSNotificationCenter defaultCenter] add
//    return true;
}
//
//+(void) checkExistingOrNot:(NSNotification *)notify{
//    if ([notify object] == nil) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"existingResult" object:[NSNumber numberWithBool:YES]];
//    }else{
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"existingResult" object:[NSNumber numberWithBool:NO]];
//    }
//}

@end
