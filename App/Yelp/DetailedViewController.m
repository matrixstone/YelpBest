//
//  DetailedViewController.m
//  Yelp
//
//  Created by Xu He on 3/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DetailedViewController.h"
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Business.h"
#import "UIImageView+AFNetworking.h"
#import "MenuClient.h"
#import "MenuCell.h"
#import "AWSClient.h"

@interface DetailedViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    
    //set up content
    self.restName.text=self.business.name;
    [self.headImage setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    [self.reviewImage setImageWithURL:[NSURL URLWithString:self.business.ratingsImageUrl]];
    self.reviewNum.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    self.distance.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    
//    NSLog(@"url :%@", self.business.url);
    NSArray* urlArray =[self.business.url componentsSeparatedByString:@"/"];
//    NSLog(@"url: %@",[self.business valueForKey:@"url"]);
//    NSLog(@"urlArray: %@",urlArray);
    self.key=[urlArray objectAtIndex: urlArray.count-1];
    NSLog(@"Key: Front %@",self.key);
    
    self.typeOfFood.text=self.business.categories;
    if (self.business.isClosed == 0) {
        self.status.text=@"Open";
    }else{
        self.status.text=@"Closed";
    }
    NSString *displayAddress=@"";
    for (NSString *add in [self.business.location valueForKey:@"display_address"]) {
        displayAddress=[displayAddress stringByAppendingString:add];
    }
    
    [self.address setTitle:displayAddress forState:UIControlStateNormal];
    CLLocationCoordinate2D centerCoordinate;
    NSString *laa=[[self.business.location valueForKey:@"coordinate"] valueForKey:@"latitude"];
    NSString *lon=[[self.business.location valueForKey:@"coordinate"] valueForKey:@"longitude"];
    centerCoordinate.latitude =[laa doubleValue];
    centerCoordinate.longitude =[lon doubleValue];
    NSLog(@"laaa: %f", centerCoordinate.latitude);
    
    MenuClient *mc=[[MenuClient alloc]init];
    [mc getMenu:self.key];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMenu:) name:@"menuJson" object:nil];
//    NSLog(@"latitude: %d", centerCoordinate.latitude);
//   
//    NSLog(@"coordinate: %@", laa);
//    NSLog(@"coordinate: %f", [laa doubleValue]);
//    NSLog(@"coordinate: %d", [[[self.business.location valueForKey:@"coordinate"] valueForKey:@"latitude"] doubleValue]);
//    centerCoordinate.longitude =[[[self.business.location valueForKey:@"coordinate"] valueForKey:@"longitude"] doubleValue];
    MKCoordinateRegion coorRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000, 1000);
    [self.mapView setRegion:coorRegion animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate=centerCoordinate;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
    
//    NSLog(@"Test");
//    [[LocationManager instance] addLocationObserver:self block:^(NSNotification *note) {
//        
//        CLLocation *location = note.userInfo[@"location"];
////        NSLog(@"vc: location : %@", location);
//        
//        MKCoordinateRegion coorRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
//        [self.mapView setRegion:coorRegion animated:YES];
//    }];
// [self.locationManager startUpdatingLocation];
// Do any additional setup after loading the view from its nib.
    

//    [self.tableView reloadData];
}

-(void) setMenu:(NSNotification *)notify{
    NSDictionary *menuJson=[notify object];
    NSLog(@"Json: %@",menuJson);
    NSLog(@"Back Key: %@", self.key);
    self.menuArray=menuJson[self.key];
    for (NSDictionary *eachMenu in self.menuArray) {
        NSLog(@"%@", eachMenu[@"down"]);
    }
    [self.tableView reloadData];
//    NSLog(@"menu: %@", menuJson);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuCell *mc=[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    NSLog(@"menu: %@", self.menuArray[indexPath.row][@"name"]);
    mc.dishName.text=self.menuArray[indexPath.row][@"name"];
//    NSLog(@"up: %@", self.menuArray[indexPath.row][@"up"]);
    mc.upNum.text=[NSString stringWithFormat:@"%@", self.menuArray[indexPath.row][@"up"]];
    mc.downNum.text=[NSString stringWithFormat:@"%@", self.menuArray[indexPath.row][@"down"]];
    mc.reviewNum.text=[NSString stringWithFormat:@"%@", self.menuArray[indexPath.row][@"review"]];
    mc.keyString=self.key;
//    mc.resturantName=self.restName;
//    mc.downNum.text=self.menuArray[indexPath.row][@"down"];
//    mc.reviewNum.text=self.menuArray[indexPath.row][@"review"];
    return mc;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
