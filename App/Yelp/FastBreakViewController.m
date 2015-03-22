//
//  FastBreakViewController.m
//  Yelp
//
//  Created by Xu He on 3/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FastBreakViewController.h"
#import "MenuCell.h"
#import "UIImageView+AFNetworking.h"
#import "MenuClient.h"

@interface FastBreakViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation FastBreakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    self.tableView.tableHeaderView
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    
    //set upt content
    self.resturantName.text=self.business.name;
//    [self.headImage setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    [self.yelpReview setImageWithURL:[NSURL URLWithString:self.business.ratingsImageUrl]];
    self.reviewLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    self.resturantType.text=self.business.categories;
//    self.distance.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    
    NSArray* urlArray =[self.business.url componentsSeparatedByString:@"/"];
    //    NSLog(@"url: %@",[self.business valueForKey:@"url"]);
    //    NSLog(@"urlArray: %@",urlArray);
    self.key=[urlArray objectAtIndex: urlArray.count-1];
//    NSLog(@"Key: Front %@",self.key);
    
    NSString *displayAddress=@"";
    for (NSString *add in [self.business.location valueForKey:@"display_address"]) {
        displayAddress=[displayAddress stringByAppendingString:add];
    }
    self.address.text=displayAddress;
    
    CLLocationCoordinate2D centerCoordinate;
    NSString *laa=[[self.business.location valueForKey:@"coordinate"] valueForKey:@"latitude"];
    NSString *lon=[[self.business.location valueForKey:@"coordinate"] valueForKey:@"longitude"];
    centerCoordinate.latitude =[laa doubleValue];
    centerCoordinate.longitude =[lon doubleValue];
//    NSLog(@"laaa: %f", centerCoordinate.latitude);
    MKCoordinateRegion coorRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000, 1000);
    [self.mapView setRegion:coorRegion animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate=centerCoordinate;
    [self.mapView addAnnotation:point];
    
    MenuClient *mc=[[MenuClient alloc]init];
    [mc getMenu:self.key];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMenu:) name:@"menuJson" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setMenu:(NSNotification *)notify{
    NSDictionary *menuJson=[notify object];
//    NSLog(@"Json: %@",menuJson);
//    NSLog(@"Back Key: %@", self.key);
    self.menuArray=menuJson[self.key];
//    for (NSDictionary *eachMenu in self.menuArray) {
////        NSLog(@"%@", eachMenu[@"down"]);
//    }
    [self.tableView reloadData];
    //    NSLog(@"menu: %@", menuJson);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuCell *mc=[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
//    NSLog(@"menu: %@", self.menuArray[indexPath.row][@"name"]);
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
