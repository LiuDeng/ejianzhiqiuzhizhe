//
//  AllDeliverView.h
//  ejianzhi
//
//  Created by 小哥 on 15/7/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectControl.h"
#import "UserDetail.h"
#import "PageSplitingManager.h"
#import "JianZhi.h"
enum AllDeliverViewStatus{
    deleteStatus = 1,
    normalStatus = 2
};

@protocol AllDeliverViewDelegate <NSObject>

- (void)didSelectedRowToPushJobDetail:(JianZhi *)jianzhi;
- (void)deleteSelectRow:(NSString *)shenqingId;
- (void)deleteDeselectRow:(NSString *)shenqingId;

@end

@interface AllDeliverView : UIView<ConnectControlDelegate,UITableViewDataSource, UITableViewDelegate>
{
    ConnectControl *connectCtr;
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *moreArray;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic,strong) PageSplitingManager *pageManager;
@property (nonatomic, strong) AVQuery *mainQuery;
@property (nonatomic, assign) int status;

@property (nonatomic, weak) id<AllDeliverViewDelegate> delegate;

- (void)refreshView;
@end
