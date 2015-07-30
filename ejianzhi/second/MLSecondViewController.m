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
#import "MBProgressHUD+Add.h"
#import "ChatViewController.h"

@interface MLSecondViewController () <FeedBackNotifViewDelegate, AllDeliverViewDelegate>
{
    DVSwitch *switcher;
    UIButton *rightButton;
    UIButton *deleteButton;
}
@property (nonatomic, retain) NSMutableArray *deleteArray;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) AllDeliverView *allDeliverView;
@property (nonatomic, strong) FeedBackNotifView *feedBackNotifView;
@end

@implementation MLSecondViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _deleteArray = [NSMutableArray arrayWithCapacity:0];
    if (self.currentPage==0)
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    else if (self.currentPage==1)
        [self.mainScrollView setContentOffset:CGPointMake([[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
    
    [switcher forceSelectedIndex:self.currentPage animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavView];
    
    [self initScrollView];
    [self switchInit];
}

- (void)createNavView
{
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateSelected];
    rightButton.frame = CGRectMake(SCREENWIDTH-58, 9, 38, 25);
    [rightButton addTarget:self action:@selector(editDelegateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightButton];
    rightButton.hidden = NO;
    
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    deleteButton.frame = CGRectMake(SCREENWIDTH-58-27, 12, 15, 19);
    [deleteButton addTarget:self action:@selector(deleteToudiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:deleteButton];
    deleteButton.hidden = YES;
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t.font = [UIFont systemFontOfSize:20.0];
    t.textColor = [UIColor whiteColor];
    t.backgroundColor = [UIColor clearColor];
    t.textAlignment = NSTextAlignmentCenter;
    t.text = @"投递列表";
    self.navigationItem.titleView = t;
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
    _allDeliverView.status = normalStatus;
    _allDeliverView.delegate = self;
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

#pragma mark FeedBackDelegate
-(void)didPushChatVC:(ChatViewController *)vc
{
    rightButton.hidden = YES;
    deleteButton.hidden = YES;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark AllDeliverViewDelegate
-(void)didSelectedRowToPushJobDetail:(JianZhi *)jianzhi
{
    rightButton.hidden = YES;
    deleteButton.hidden = YES;
    JobDetailVC *detailVC=[[JobDetailVC alloc]initWithData:jianzhi];
    detailVC.hidesBottomBarWhenPushed=YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)deleteSelectRow:(NSString *)shenqingId
{
    [_deleteArray addObject:shenqingId];
}

-(void)deleteDeselectRow:(NSString *)shenqingId
{
    [_deleteArray removeObject:shenqingId];
}

#pragma mark 右上角编辑按钮
- (void)editDelegateAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        _allDeliverView.tableView.editing = YES;
        deleteButton.hidden = NO;
        _allDeliverView.status = deleteStatus;
    }
    else
    {
        _allDeliverView.tableView.editing = NO;
        deleteButton.hidden = YES;
        _allDeliverView.status = normalStatus;
    }
    
}

#pragma mark 删除按钮事件
- (void)deleteToudiAction:(UIButton *)sender
{
    if (_deleteArray.count > 0)
    {
        for (int i = 0; i<_deleteArray.count; i++)
        {
            AVQuery *query = [AVQuery queryWithClassName:@"JianZhiShenQing"];
            [query whereKey:@"objectId" equalTo:[_deleteArray objectAtIndex:i]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error)
                {
                    if (objects.count)
                    {
                        AVObject *obj = [objects objectAtIndex:0];
                        [obj deleteInBackground];
                        [_allDeliverView.dataArray removeObject:obj];
                        [_allDeliverView.tableView reloadData];
                    }
                }
                else
                {
                    [MBProgressHUD showError:@"操作失败" toView:self.view];
                }
            }];
        }
    }
    else
    {
        [MBProgressHUD showError:@"请选择要删除的投递项" toView:self.view];
    }
    NSLog(@"%@",_deleteArray);
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
