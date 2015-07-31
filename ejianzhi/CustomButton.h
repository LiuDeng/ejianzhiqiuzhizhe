//
//  CustomButton.h
//  ejianzhi
//
//  Created by 小哥 on 15/7/31.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
@property (nonatomic, retain) UILabel *titlLabel;
@property (nonatomic, retain) UIImageView *iv;
-(CustomButton *)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName withTitle:(NSString *)title;

@end
