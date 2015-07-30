//
//  AllDeliverView.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "AllDeliverView.h"
#import "MJRefresh.h"
#import "AllDeliverTableViewCell.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "DateUtil.h"

@implementation AllDeliverView 

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        _moreArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.pageManager = [[PageSplitingManager alloc] initWithPageSize:10];
        [self initView];
    }
    return self;
}

- (void)refreshView{
    connectCtr = [ConnectControl showForView:self];
    connectCtr.delegate=self;
    
    if (connectCtr.superview!=nil && connectCtr.loading==NO)
    {
        [connectCtr setLoading:YES];
    }
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [vc.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        // 增加5条假数据
        //        for (int i = 0; i<5; i++) {
        //            [vc.fakeColors insertObject:MJRandomColor atIndex:0];
        //        }
        // 模拟延迟加载数据，因此2秒后才调用）
        [self refreshTableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.tableView headerEndRefreshing];
        });
    }];
    
#warning 自动刷新(一进入程序就下拉刷新)
    //    [self.movieDetailView headerBeginRefreshing];
}

- (void)addFooter
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [vc.tableView addFooterWithCallback:^{
        [self loadMoreData];
        // 进入刷新状态就会回调这个Block
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [vc.tableView footerEndRefreshing];
        });
        
    }];
    
}

- (void)setMainQuery
{
    self.mainQuery = [AVQuery queryWithClassName:@"JianZhiShenQing"];
    self.pageManager.pageSize=10;
    self.mainQuery.skip=[self.pageManager getNextStartAt];
    self.mainQuery.limit=10;
    self.mainQuery.cachePolicy=kAVCachePolicyNetworkElseCache;
}

- (void)connect
{
    [self setMainQuery];
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser)
    {
        AVQuery *query = [AVQuery queryWithClassName:@"UserDetail"];
        [query whereKey:@"userObjectId" equalTo:currentUser.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [ConnectControl removeFromView:self];
            if (!error)
            {
                if (objects.count > 0)
                {
                    UserDetail *userDetail = [objects objectAtIndex:0];
                    
                    [self.mainQuery whereKey:@"userDetail" equalTo:userDetail];
                    [self.mainQuery includeKey:@"jianZhi"];
                    [self.mainQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error)
                        {
                            [self.pageManager pageLoadCompleted];
                            if (objects.count > 0)
                            {
                                
                                
                                [_moreArray addObjectsFromArray:objects];
                                _dataArray = _moreArray;
                                self.tableView.hidden = NO;
                                [self.tableView reloadData];
                                
                            }
                            else
                            {
                                if (self.pageManager.pagination == 1)
                                {
                                    // 没有投递过
                                    self.tableView.hidden = YES;
                                }
                                else
                                {
                                    // 没有更多了
                                    [MBProgressHUD showSuccess:@"没有更多了" toView:self];
                                }
                            }
                        }
                        else
                        {
                            [MBProgressHUD showError:@"加载出错" toView:self];
                        }
                    }];
                }
                else
                {
                    [self.tableView reloadData];
                    self.tableView.hidden = YES;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有创建简历" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            else
            {
                [MBProgressHUD showError:@"加载出错" toView:self];
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    [self addHeader];
    [self addFooter];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identified = @"AllDeliverTableViewCell";
    AllDeliverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identified];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllDeliverTableViewCell" owner:self options:nil] lastObject];
    }
    AVObject *obj = [_dataArray objectAtIndex:indexPath.row];
    JianZhi *jianzhi = [obj objectForKey:@"jianZhi"];
    [cell setContentWithJianzhi:jianzhi andToudiData:[DateUtil msgTimetoCurrent:[obj objectForKey:@"createdAt"]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)refreshTableView
{
    [self.pageManager resetPageSplitingManager];
    _moreArray = [NSMutableArray arrayWithCapacity:0];
    [self connect];
}

- (void)loadMoreData
{
    [self connect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
