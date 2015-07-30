//
//  MLTabbarVC.h
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLFirstVC.h"
#import "MLForthVC.h"
#import "MLSecondViewController.h"
@interface MLTabbarVC : UITabBarController
+(MLTabbarVC*)shareInstance;
@property (strong,nonatomic)MLFirstVC *firstVC;
@property (nonatomic, strong) MLSecondViewController *secondVC;
@property (strong,nonatomic)MLForthVC *forthVC;
@end
