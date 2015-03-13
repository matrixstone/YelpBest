//
//  MenuClient.h
//  Yelp
//
//  Created by Xu He on 3/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuClient : NSObject

-(void)getMenu:(NSString *)resturantName;
-(void)updateMenu:(NSString *)resturantName with:(NSString *) dish name:(NSString *)up param:(NSString *)value;
@end
