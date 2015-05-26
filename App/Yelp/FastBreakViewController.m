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
#import "AWSClient.h"
#import <AWSSNS/AWSSNS.h>
//#import <AWSDynamoDB/AWSDynamoDB.h>

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
    
//    MenuClient *mc=[[MenuClient alloc]init];
//    [mc getMenu:self.key];
    
    AWSClient *aclient=[[AWSClient alloc]initCredentials];
    [aclient getBasedOnKey:self.key];
   
    
//    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMenu:) name:@"menuDict" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setMenu:(NSNotification *)notify{
    //Example of the menu dictionary:
//    2015-05-25 19:13:21.705 Yelp[83265:16650917] menuDict: {
//        RestaurantID = "chef-yu-hunan-gourmet-sunnyvale";
//        "chow fun" = "{u'down': 0, u'review': u'4', u'name': u'chow fun', u'up': 0}";
//        "fried rice" = "{u'down': 0, u'review': u'7', u'name': u'fried rice', u'up': 0}";
//        "orange peel beef" = "{u'down': 0, u'review': u'4', u'name': u'orange peel beef', u'up': 0}";
//        "pot sticker" = "{u'down': 0, u'review': u'4', u'name': u'pot sticker', u'up': 0}";
//        "sour soup" = "{u'down': 0, u'review': u'8', u'name': u'sour soup', u'up': 0}";
//        "spicy dishe" = "{u'down': 0, u'review': u'5', u'name': u'spicy dishe', u'up': 0}";
//    }
    BFTask *task=[notify object];
    self.menuDict=task.result;
//    NSLog(@"menuDict: %@", self.menuDict);
    NSMutableArray *tempMenuArray=[[NSMutableArray alloc]init];
    for (NSString *key in self.menuDict) {
//        NSLog(@"Key: %@", key);
        if (![key isEqualToString:@"RestaurantID"]) {
            NSString *jsonString=[self.menuDict objectForKey:key];
            NSString *replaceString=[[jsonString stringByReplacingOccurrencesOfString:@"u'" withString:@"'"] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
//            NSString *appendString=[[@"\"" stringByAppendingString:replaceString] stringByAppendingString:@"\""];
            NSData *data = [replaceString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [tempMenuArray addObject:jsonDict];

        }
    }

    self.menuArray = [tempMenuArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        int reviewNum1=[[obj1 objectForKey:@"review"] intValue];
        int reviewNum2=[[obj2 objectForKey:@"review"] intValue];
        if (reviewNum1 < reviewNum2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (reviewNum1 > reviewNum2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        [self.tableView reloadData];
        return (NSComparisonResult)NSOrderedSame;
    }];
    
//    NSDictionary *menuJson=[notify object];
////    NSLog(@"Json: %@",menuJson);
////    NSLog(@"Back Key: %@", self.key);
//    self.menuArray=menuJson[self.key];
////    for (NSDictionary *eachMenu in self.menuArray) {
//////        NSLog(@"%@", eachMenu[@"down"]);

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
    mc.menuDict=self.menuDict;
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
