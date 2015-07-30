//
//  FeedBackNotifView.h
//  ejianzhi
//
//  Created by 小哥 on 15/7/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatListViewController.h"

@protocol FeedBackNotifViewDelegate <NSObject>

-(void)didPushChatVC:(ChatViewController *)vc;

@end

@interface FeedBackNotifView : UIView <ChatListViewControllerDelegate>

@property (nonatomic, strong) ChatListViewController *chatListVC;
@property (nonatomic, weak) id<FeedBackNotifViewDelegate> delegate;
@end
