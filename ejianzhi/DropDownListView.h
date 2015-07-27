//
//  DropDownListView.h
//  ejianzhi
//
//  Created by Mac on 15/7/23.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropDownListView;
@protocol DropDownMenDataSource <NSObject>

@required
- (NSInteger)menu:(DropDownListView *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)menu:(DropDownListView *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma - mark - delegate

@protocol DropDownMenuDelegate <NSObject>
@optional
- (void)menu:(DropDownListView *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface DropDownListView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong)UITableView *leftTableView;
@property (nonatomic,strong)UITableView *rightTableView;

@property (nonatomic, strong) UIView *transformView;

@property (nonatomic, weak) id <DropDownMenDataSource> dataSource;
@property (nonatomic, weak) id <DropDownMenuDelegate> delegate;

- (instancetype)initwithOrigin:(CGPoint)orgin andHeight:(CGFloat)height;

-(void)menuTapped;

@end
