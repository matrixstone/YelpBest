//
//  FastBreakViewController.h
//  Yelp
//
//  Created by Xu He on 3/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Business.h"

@interface FastBreakViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *resturantName;
@property (weak, nonatomic) IBOutlet UILabel *resturantType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIImageView *yelpReview;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *openTime;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (nonatomic, strong) Business *business;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSDictionary *menuDict;
@property (strong, nonatomic) NSString *key;

-(void) setMenu:(NSNotification *)notify;
@end
