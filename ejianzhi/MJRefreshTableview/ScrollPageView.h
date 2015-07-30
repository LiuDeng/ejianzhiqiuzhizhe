//
//  ScrollPageView.h
//  TVFan
//
//  Created by apple on 12-11-28.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
@interface ScrollPageView : UIView<UIScrollViewDelegate>
{
 
}


@property(nonatomic,retain)UIScrollView *scroll;
@property(nonatomic,retain)SMPageControl *pageControl;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,retain)UILabel *infoLabel;
@property(nonatomic,retain)NSArray *infos;


//- (id)initWithFrame:(CGRect)frame images:(NSArray *)images;
- (id)initWithFrame:(CGRect)frame views:(NSArray *)views infos:(NSArray *)infos;
-(void)updateWithViews:(NSArray *)views;

@end
