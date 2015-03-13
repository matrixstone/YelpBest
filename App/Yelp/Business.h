//
//  Business.h
//  Yelp
//
//  Created by Xu He on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (nonatomic, strong)  NSString *imageUrl;
@property (nonatomic, strong)  NSString *name;
@property (nonatomic, strong)  NSString *ratingsImageUrl;
@property (nonatomic, assign)  NSInteger numReviews;
@property (nonatomic, strong)  NSString *address;
@property (nonatomic, strong)  NSString *categories;
@property (nonatomic, assign)  CGFloat distance;
@property (nonatomic, assign)  NSInteger isClosed;
@property (nonatomic, strong)  NSDictionary *location;

+ (NSArray *)businessWithDictionaries:(NSArray *)dictionaries;

@end
