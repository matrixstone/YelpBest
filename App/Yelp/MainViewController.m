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

NSString * const kYelpConsumerKey = @"45fcmgyIjxMk-J-5GeTVjQ";
NSString * const kYelpConsumerSecret = @"qWFkA9aUJps0YSz1RMBaErlcDwY";
NSString * const kYelpToken = @"jWc_WzCrqpdrMb4B1gx2N7lixEi6msNu";
NSString * const kYelpTokenSecret = @"5bi4id__4I8wst5mPvXCRdtGb8w";

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong)  NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params;
@property (nonatomic, strong) BusinessCell *prototypeCell;

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
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessWithQuery:@"Resturants" params:nil];
        
    }
    return self;
}

-(void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params{
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
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
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    
    self.title=@"Yelp";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
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
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

#pragma mark - Filter delegate methods

-(void) filtersViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters{
    [self fetchBusinessWithQuery:@"Resturants" params:filters];
    NSLog(@"Fire new netwroking event: %@", filters);
    
}


#pragma mark - Private methods

-(void)onFilterButton{
    FilterViewController *vc=[[FilterViewController alloc]init];
    vc.delegate=self;
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
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

@end
