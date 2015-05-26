//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FilterViewController.h"
#import "DetailedViewController.h"
#import "SelectViewController.h"
#import "FastBreakViewController.h"
#import "LocationManager.h"

NSString * const kYelpConsumerKey = @"45fcmgyIjxMk-J-5GeTVjQ";
NSString * const kYelpConsumerSecret = @"qWFkA9aUJps0YSz1RMBaErlcDwY";
NSString * const kYelpToken = @"jWc_WzCrqpdrMb4B1gx2N7lixEi6msNu";
NSString * const kYelpTokenSecret = @"5bi4id__4I8wst5mPvXCRdtGb8w";

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong)  NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params locationSelect:(NSInteger) locationIndex;
@property (nonatomic, strong) BusinessCell *prototypeCell;

@property (nonatomic, assign) NSInteger locationIndex;
@property (nonatomic, assign) float verticalContentOffset;

@end

@implementation MainViewController

- (BusinessCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    }
    return _prototypeCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"locationIndex"];
        self.verticalContentOffset=0.0;
        
    }
    return self;
}

-(void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params locationSelect:(NSInteger) locationIndex{
    [self.client searchWithTerm:query params:params locationSelect:locationIndex success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"response: %@", response);
        NSArray *businessArray = response[@"businesses"];
        self.businesses = [Business businessWithDictionaries:businessArray];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.locationIndex=[defaults integerForKey:@"locationIndex"];
    
    
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    [self fetchBusinessWithQuery:@"Resturants" params:nil locationSelect:self.locationIndex];
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    
//    self.title=@"Yelp";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(onSelectButton)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
   
}

-(void)viewWillDisappear:(BOOL)animated{

}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    
    if (self.locationIndex == [defaults integerForKey:@"locationIndex"]) {
//        NSLog(@"location index is same");
    }else{
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self fetchBusinessWithQuery:@"Resturants" params:nil locationSelect:self.locationIndex];
    }
     [self.tableView setContentOffset:CGPointMake(0, self.verticalContentOffset)];
    NSLog(@"set vertical: %f", self.verticalContentOffset);
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businesses.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.verticalContentOffset=self.tableView.contentOffset.y;
//    NSLog(@"vertical off set: %f", self.verticalContentOffset);
    
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

#pragma mark - Filter delegate methods

-(void) filtersViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters{
    [self fetchBusinessWithQuery:@"Resturants" params:filters locationSelect:self.locationIndex];
    NSLog(@"Fire new netwroking event: %@", filters);
    
}


#pragma mark - Private methods

-(void)onFilterButton{
    FilterViewController *vc=[[FilterViewController alloc]init];
    vc.delegate=self;
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)onSelectButton{
    SelectViewController *vc=[[SelectViewController alloc]init];
//    vc.delegate=self;
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DetailedViewController *dvc=[[DetailedViewController alloc]init];
//    dvc.business=self.businesses[indexPath.row];
//    [self.navigationController pushViewController:dvc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FastBreakViewController *dvc=[[FastBreakViewController alloc]init];
    dvc.business=self.businesses[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
////    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
//    self.prototypeCell.business = self.businesses[indexPath.row];
//    [self.prototypeCell layoutIfNeeded];
//    
//    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (IBAction)clickSearch:(id)sender {
//    NSLog(@"Text content: %@", self.searchField.text);
    [self fetchBusinessWithQuery:self.searchField.text params:nil locationSelect:self.locationIndex];
    [self.tableView reloadData];
}
@end
