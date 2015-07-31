//
//  CustomButton.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/31.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

-(UIButton *)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titlLabel = [[UILabel alloc] init];
        _titlLabel.backgroundColor = [UIColor clearColor];
        _titlLabel.textColor = [UIColor blackColor];
        _titlLabel.font = [UIFont systemFontOfSize:15.0f];
        _titlLabel.text = title;
        _titlLabel.textAlignment = NSTextAlignmentCenter;
        CGSize titleSize = [_titlLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:15.0f] constrainedToSize:CGSizeMake(MAXFLOAT, frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        _titlLabel.frame = CGRectMake((frame.size.width- (titleSize.width+11+7))/2, (frame.size.height-titleSize.height)/2, titleSize.width, titleSize.height);
        [self addSubview:_titlLabel];
        
        _iv = [[UIImageView alloc] initWithFrame:CGRectMake(_titlLabel.frame.origin.x+titleSize.width+7, 17, 11, 5)];
        _iv.image =[UIImage imageNamed:imageName];
        [self addSubview:_iv];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
