//
//  MLTabbarVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLTabbarVC.h"
#import "MLNavi.h"


//tabViewController


#import "JobListTableViewController.h"
#import "JobListWithDropDownListVCViewController.h"
@interface MLTabbarVC ()



@end

@implementation MLTabbarVC

static  MLTabbarVC *thisController=nil;

+(MLTabbarVC*)shareInstance
{
    if (thisController==nil) {
        thisController=[[MLTabbarVC alloc] init];
    }
    return thisController;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(MLFirstVC*)firstVC
{
  if(_firstVC==nil)
  {
      _firstVC=[[MLFirstVC alloc]init];
  }
    return _firstVC;

}

-(MLForthVC*)forthVC
{
    if (_forthVC==nil) {
        _forthVC=[[MLForthVC alloc]init];
    }
    return  _forthVC;
}

- (MLSecondViewController *)secondVC
{
    if (_secondVC == nil)
    {
        _secondVC = [[MLSecondViewController alloc] init];
    }
    return _secondVC;
}

-(MLNavi*)makeRootByNavigationController:(UIViewController*) childVC
{
    @try {
        if (childVC==nil) {
            return [[MLNavi alloc]initWithRootViewController:[[UIViewController alloc]init]];
        }
        return [[MLNavi alloc]initWithRootViewController:childVC];
    }
    @catch (NSException *exception) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self viewControllersInit];
}

-(void)viewControllersInit
{

    UIViewController *pageOneVC=[self makeRootByNavigationController:self.firstVC];
    
    UIViewController *pageTwoVC=[self makeRootByNavigationController:self.secondVC];
    
    //UIViewController *pageThreeVC=[self makeRootByNavigationController:self.chatVC];

    UIViewController *pageFourVC=[self makeRootByNavigationController:self.forthVC];
    
    self.viewControllers=@[pageOneVC,pageTwoVC,pageFourVC];
    
    [self changeTabbarStyle];
}

-(void)changeTabbarStyle
{
    
    [self.tabBar setTintColor:NaviBarColor];
    self.tabBar.translucent=NO;
    
    UITabBar *tabBar=self.tabBar;

    UITabBarItem *tabBarItem1=[tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2=[tabBar.items objectAtIndex:1];
    //UITabBarItem *tabBarItem3=[tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4=[tabBar.items objectAtIndex:2];
    
    tabBarItem1.title=@"首页";
    
    tabBarItem2.title=@"投递";
    
    //tabBarItem3.title=@"消息";
    
    tabBarItem4.title=@"我";
    

    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[[UIImage imageNamed:@"首页选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"首页未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"投递选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"投递未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //[[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[[UIImage imageNamed:@"消息icon(高亮)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"消息icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[[UIImage imageNamed:@"我的选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"我的未选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (void)viewWillLayoutSubviews{
    
    //[self.tabBar setSelectedImageTintColor: [UIColor colorWithRed:0.90 green:0.39 blue:0.22 alpha:1.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
