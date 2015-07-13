//
//  TopView.h
//  ejianzhi
//
//  Created by 小哥 on 15/7/11.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JianZhi.h"

@protocol TopViewDelegate <NSObject>

- (void)topViewClick;

@end

@interface TopView : UIView

@property (nonatomic, strong) UIView *typeView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *wageLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *salaryType;

@property (nonatomic, weak) id<TopViewDelegate> delegate;

- (void)setContentValue:(JianZhi *)jianzhi;

@end
