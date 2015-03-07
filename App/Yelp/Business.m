 //
//  Business.m
//  Yelp
//
//  Created by Xu He on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

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
    NSMutableArray *businesses=[NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Business *business = [[Business alloc]initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    return businesses;
}

@end
