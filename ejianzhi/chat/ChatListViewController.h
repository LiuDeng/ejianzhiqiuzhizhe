/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "ChatViewController.h"

@protocol ChatListViewControllerDelegate <NSObject>

- (void)didselecteAction:(ChatViewController *)vc;

@end

@interface ChatListViewController : UIViewController

- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;
@property (nonatomic, weak) id<ChatListViewControllerDelegate> delegate;

@end
