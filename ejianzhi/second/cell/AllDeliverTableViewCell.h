//
//  AllDeliverTableViewCell.h
//  ejianzhi
//
//  Created by 小哥 on 15/7/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JianZhi.h"

@interface AllDeliverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *jinduImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void)setContentWithJianzhi:(JianZhi *)jianzhi andToudiData:(NSString *)date;

@end
