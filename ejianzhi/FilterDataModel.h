//
//  FilterDataModel.h
//  ejianzhi
//
//  Created by 小哥 on 15/7/31.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterDataModel : NSObject

+ (NSMutableArray *)loadLeftDataWithFilteType:(NSInteger)typeIndex;

+ (NSMutableArray *)loadRightDataWithFilterType:(NSInteger)typeIndex;

+ (NSArray *)loadTypeTitleArray;
@end
