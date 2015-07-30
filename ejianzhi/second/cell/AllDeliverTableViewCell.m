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

-(void)setContentWithJianzhi:(JianZhi *)jianzhi andToudiData:(NSString *)date andenterpriseHandleResult:(NSString *)enterpriseHandleResult
{
    _offerImageView.hidden = YES;
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
    if ([enterpriseHandleResult isEqualToString:@"已投递"])
    {
        
    }
    else if ([enterpriseHandleResult isEqualToString:@"被查看"])
    {
        
    }
    else if ([enterpriseHandleResult isEqualToString:@"待沟通"])
    {
        
    }
    else if ([enterpriseHandleResult isEqualToString:@"录用"])
    {
        _offerImageView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
