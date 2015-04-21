//
//  JobListTableViewCell.m
//  EJianZhi
//
//  Created by Mac on 1/24/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import "JobListTableViewCell.h"

@implementation JobListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.IconView.type=WithBadge;
    
    self.IconView.backgroundColor=GreenFillColor;
    //设置圆角
    [self.IconView.layer setMasksToBounds:YES];
    [self.IconView.layer setCornerRadius:10.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setInsuranceImageShow:(BOOL)ishidden
{
    self.Icon1ImageView.hidden=ishidden;
}


- (void)setWeekendImageShow:(BOOL)ishidden
{
    self.Icon2ImageView.hidden=ishidden;
    
}
- (void)setotherImageShow:(BOOL)ishidden
{
    
    self.Icon3ImageView.hidden=ishidden;
    
}



@end
