//
//  SelectViewController.m
//  Yelp
//
//  Created by Xu He on 3/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SelectViewController.h"

@interface SelectViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *selector;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSaveButton:(id)sender {
    int locationIndex=self.selector.selectedSegmentIndex;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:locationIndex forKey:@"locationIndex"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
