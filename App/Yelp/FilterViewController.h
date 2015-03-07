//
//  FilterViewController.h
//  Yelp
//
//  Created by Xu He on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

-(void)filtersViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters;

@end

@interface FilterViewController : UIViewController

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@end
