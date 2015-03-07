//
//  SwitchCell.h
//  Yelp
//
//  Created by Xu He on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwtichCellDelegate <NSObject>

-(void)switchCell: (SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) id<SwtichCellDelegate> delegate;

-(void)setOn:(BOOL)on animated:(BOOL)animated;

@end
