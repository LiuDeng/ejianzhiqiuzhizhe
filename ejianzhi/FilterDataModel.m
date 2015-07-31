//
//  FilterDataModel.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/31.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "FilterDataModel.h"

@implementation FilterDataModel

+(NSMutableArray *)loadLeftDataWithFilteType:(NSInteger)typeIndex
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"filterData" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:[[self loadTypeTitleArray] objectAtIndex:typeIndex]];
    return [NSMutableArray arrayWithArray:[dict allKeys]];
}

+(NSMutableArray *)loadRightDataWithFilterType:(NSInteger)typeIndex
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"filterData" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary dictionaryWithContentsOfFile:filePath] objectForKey:[[self loadTypeTitleArray] objectAtIndex:typeIndex]];
    NSMutableArray *rightData = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<[dict allKeys].count; i++)
    {
        NSArray *a = [dict objectForKey:[[dict allKeys] objectAtIndex:i]];
        [rightData addObject:a];
    }
    return rightData;
}

+(NSArray *)loadTypeTitleArray
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"filterData" ofType:@"plist"];
    NSArray *array = [[NSDictionary dictionaryWithContentsOfFile:filePath] allKeys];
    
    return @[@"岗位类型",@"地理位置", @"综合筛选"];
}

@end
