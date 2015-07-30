//
//  MLSecondViewController.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "MLSecondViewController.h"
#import "DVSwitch.h"
#import "AllDeliverView.h"
#import "FeedBackNotifView.h"
#import "ChatViewController.h"

@interface MLSecondViewController () <FeedBackNotifViewDelegate>
{
    DVSwitch *switcher;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) AllDeliverView *allDeliverView;
@property (nonatomic, strong) FeedBackNotifView *feedBackNotifView;
@end

@implementation MLSecondViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.currentPage==0)
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    else if (self.currentPage==1)
        [self.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
    
    [switcher forceSelectedIndex:self.currentPage animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:20.0];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = UITextAlignmentCenter;
    t.text = @"投递列表";
    self.navigationItem.titleView = t;
    [self initScrollView];
    [self switchInit];
}

- (void)initScrollView
{
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, SCREENHEIGHT-64-49-35)];
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.pagingEnabled = YES;
    [self.view addSubview:self.mainScrollView];
    
    
    _allDeliverView = [[AllDeliverView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-49-35)];
    [_allDeliverView refreshView];
    [self.mainScrollView addSubview:_allDeliverView];
    
    _feedBackNotifView = [[FeedBackNotifView alloc] initWithFrame:CGRectMake(SCREENWIDTH*1, 0, SCREENWIDTH, SCREENHEIGHT-64-49-35)];
    _feedBackNotifView.delegate = self;
    [self.mainScrollView addSubview:_feedBackNotifView];
    
}

- (void)switchInit
{
    self.currentPage=0;
    
    switcher = [DVSwitch switchWithStringsArray:@[@"全部投递", @"反馈通知"]];
    switcher.font = [UIFont boldSystemFontOfSize:15.0f];
    switcher.frame = CGRectMake(0, 1,[[UIScreen mainScreen] bounds].size.width, 34);
    switcher.backgroundColor = COLOR(226, 241, 235);
    switcher.sliderColor = COLOR(68, 170, 128);
    switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    switcher.labelTextColorOutsideSlider = COLOR(68, 170, 128);
    switcher.cornerRadius = 0;
    switcher.sliderType=blockSlider;
    
    __weak typeof(self) weakSelf = self;
    
    [switcher setWillBePressedHandler:^(NSUInteger index) {
        if (index==0){
            [weakSelf.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            weakSelf.currentPage=0;
        }
        else if (index==1){
            [weakSelf.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
            weakSelf.currentPage=1;
        }
    }];
    
    [self.view addSubview:switcher];
}

-(void)didPushChatVC:(ChatViewController *)vc
{
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
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
