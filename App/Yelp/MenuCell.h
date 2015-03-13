//
//  MenuCell.h
//  Yelp
//
//  Created by Xu He on 3/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UILabel *upNum;
@property (weak, nonatomic) IBOutlet UILabel *downNum;
@property (weak, nonatomic) IBOutlet UILabel *reviewNum;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) NSString *keyString;
@property (assign, nonatomic) BOOL *upOnce;
@property (assign, nonatomic) BOOL *downOnce;
//@property (strong, nonatomic) NSString *resturantName;

- (IBAction)clickUpButton:(id)sender;
- (IBAction)clickDownButton:(id)sender;


@end
