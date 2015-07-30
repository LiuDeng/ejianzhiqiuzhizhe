//
//  ConnectControl.h
//  TVFan
//
//  Created by apple on 12-12-4.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConnectControlDelegate <NSObject>

-(void)connect;

@end



@interface ConnectControl : UIControl

@property(nonatomic,assign)id<ConnectControlDelegate>delegate;

@property (nonatomic,assign) BOOL loading;


+(ConnectControl *)showForView:(UIView *)view;

+(void)removeFromView:(UIView *)view;


@end
