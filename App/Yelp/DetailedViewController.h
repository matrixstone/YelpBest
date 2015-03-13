//
//  DetailedViewController.h
//  Yelp
//
//  Created by Xu He on 3/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
#import <MapKit/MapKit.h>

@interface DetailedViewController : UIViewController
@property (nonatomic, strong) Business *business;
@property (nonatomic, strong) NSArray *menuArray;

@property (weak, nonatomic) IBOutlet UILabel *restName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *reviewImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewNum;
@property (weak, nonatomic) IBOutlet UILabel *dollar;
@property (weak, nonatomic) IBOutlet UILabel *typeOfFood;
@property (weak, nonatomic) IBOutlet UILabel *officeHour;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *writeReview;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *checkIn;
@property (weak, nonatomic) IBOutlet UIButton *bookMark;
@property (weak, nonatomic) IBOutlet UIButton *address;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) NSString *key;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void) setMenu:(NSNotification *)notify;

@end
