//
//  MenuCell.m
//  Yelp
//
//  Created by Xu He on 3/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "MenuCell.h"
#import "MenuClient.h"

@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
    self.upOnce=TRUE;
    self.downOnce=TRUE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickUpButton:(id)sender {
    if (self.upOnce == TRUE) {
        self.upOnce=FALSE;
        [UIView animateWithDuration:1 animations:^{
            self.upButton.transform=CGAffineTransformMakeScale(4, 4);
            self.upButton.transform=CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            NSInteger number=[self.upNum.text intValue];
            self.upNum.text=[NSString stringWithFormat:@"%d", number+1];
            MenuClient *mc=[[MenuClient alloc]init];
            
            [mc updateMenu:self.keyString with:self.dishName.text name:@"up" param:self.upNum.text];
            
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Click Once" message:@"Only allow click once" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (IBAction)clickDownButton:(id)sender {
    if (self.downOnce == TRUE) {
        self.downOnce=FALSE;
        [UIView animateWithDuration:1 animations:^{
            self.downButton.transform=CGAffineTransformMakeScale(4, 4);
            self.downButton.transform=CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            NSInteger number=[self.downNum.text intValue];
            self.downNum.text=[NSString stringWithFormat:@"%d", number+1];
            MenuClient *mc=[[MenuClient alloc]init];
            [mc updateMenu:self.keyString with:self.dishName.text name:@"down" param:self.downNum.text];
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Click Once" message:@"Only allow click once" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
}


@end
