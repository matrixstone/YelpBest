//
//  BusinessCell.h
//  Yelp
//
//  Created by Xu He on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
@interface BusinessCell : UITableViewCell
@property (nonatomic, strong) Business *business;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
