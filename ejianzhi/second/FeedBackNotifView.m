//
//  FeedBackNotifView.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "FeedBackNotifView.h"

@implementation FeedBackNotifView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewController];
    }
    return self;
}

- (void)initViewController
{
    _chatListVC = [[ChatListViewController alloc] init];
    _chatListVC.delegate = self;
    [self addSubview:_chatListVC.view];
}

-(void)didselecteAction:(ChatViewController *)vc
{
    if ([_delegate respondsToSelector:@selector(didPushChatVC:)])
    {
        [_delegate didPushChatVC:vc];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
