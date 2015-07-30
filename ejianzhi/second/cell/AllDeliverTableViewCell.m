//
//  AllDeliverTableViewCell.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "AllDeliverTableViewCell.h"

@implementation AllDeliverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setContentWithJianzhi:(JianZhi *)jianzhi andToudiData:(NSString *)date
{
    if (jianzhi.jianZhiTitle)
    {
        self.titleLabel.text = jianzhi.jianZhiTitle;
    }
    if (jianzhi.jianZhiWage)
    {
        self.salaryLabel.text = [NSString stringWithFormat:@"%d/%@", [jianzhi.jianZhiWage intValue], jianzhi.jianZhiWageType];
    }
    if (jianzhi.jianZhiType)
    {
        self.typeLabel.text = jianzhi.jianZhiType;
    }
    if (jianzhi.jianZhiAddress)
    {
        self.addressLabel.text = jianzhi.jianZhiAddress;
    }
    self.dataLabel.text = date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
