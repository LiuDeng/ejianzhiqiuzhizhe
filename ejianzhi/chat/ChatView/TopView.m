//
//  TopView.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/11.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "TopView.h"
#import "UIColor+ColorFromArray.h"
#import  "PullServerManager.h"
#import "MLMapManager.h"
#import "AJLocationManager.h"
#define interval 5
#define GreenFillColor [UIColor colorWithRed: 0.22 green: 0.69 blue: 0.58 alpha: 1]
@implementation TopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    _typeView = [[UIView alloc] initWithFrame:CGRectMake(interval, interval, 70, 60)];
    _typeView.layer.cornerRadius = 5;
    _typeView.layer.masksToBounds = YES;
    [self addSubview:_typeView];
    
    // 类型
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, _typeView.frame.size.width, 30)];
    _typeLabel.backgroundColor = [UIColor clearColor];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [_typeView addSubview:_typeLabel];
    
    // 标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeView.frame.origin.x+_typeView.frame.size.width+interval, interval, self.frame.size.width-_typeView.frame.size.width+interval*2, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    // 距离
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeView.frame.origin.x+_typeView.frame.size.width+interval, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, 60, 20)];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    _distanceLabel.font = [UIFont systemFontOfSize:13.0f];
    _distanceLabel.textColor = [UIColor blackColor];
    [self addSubview:_distanceLabel];
    
    // 工资
    _wageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, 100, 20)];
    _wageLabel.backgroundColor = [UIColor clearColor];
    _wageLabel.font = [UIFont systemFontOfSize:13.0f];
    _wageLabel.textColor = [UIColor blackColor];
    [self addSubview:_wageLabel];
    
    // 地址
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeView.frame.origin.x+_typeView.frame.size.width+interval, _distanceLabel.frame.origin.y+_distanceLabel.frame.size.height, self.frame.size.width-_typeView.frame.size.width+interval*2, 20)];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.font = [UIFont systemFontOfSize:13.0f];
    _addressLabel.textColor = [UIColor blackColor];
    _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _addressLabel.numberOfLines = 1;
    [self addSubview:_addressLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(showJobDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)showJobDetail:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(topViewClick)])
    {
        [_delegate topViewClick];
    }
}

-(void)setContentValue:(JianZhi *)jianzhi
{
    [self setIconBackgroundColor:[self colorForType:jianzhi.jianZhiType]];
    _typeLabel.text = jianzhi.jianZhiType;
    _titleLabel.text = jianzhi.jianZhiTitle;
    _addressLabel.text = jianzhi.jianZhiAddress;
    _wageLabel.text = [@"¥" stringByAppendingString:[jianzhi.jianZhiWage stringValue]];
    
    self.distanceLabel.text=[self distanceFromJobPoint:jianzhi.jianZhiPoint.latitude Lon:jianzhi.jianZhiPoint.longitude];
    if([self.distanceLabel.text isEqualToString:@""]){
        self.distanceLabel.hidden=YES;
    }else{
        self.distanceLabel.hidden=NO;
    }
    
    
}

-(NSString *)distanceFromJobPoint:(double)lat Lon:(double)lon
{
    if (lat>0 && lon>0) {
        
        CLLocationCoordinate2D jobP=CLLocationCoordinate2DMake(lat, lon);
        CLLocationCoordinate2D location=[AJLocationManager shareLocation].lastCoordinate;
        NSNumber *disNumber=[MLMapManager calDistanceMeterWithPointA:jobP PointB:location];
        int threshold=[disNumber intValue];
        if (threshold >100000) {
            return [NSString stringWithFormat:@">100km"];
        }else if(threshold>1000)
        {
            return [NSString stringWithFormat:@"%.2fkm",[disNumber doubleValue]/1000];
        }else if(threshold<100&&threshold>0)
        {
            return [NSString stringWithFormat:@"%dm",threshold];
        }
        
    }
    return @"";
    
}

-(UIColor*)colorForType:(NSString*)type
{
    NSUserDefaults *mysetting=[NSUserDefaults standardUserDefaults];
    NSDictionary *typeAndColorDict=[mysetting objectForKey:TypeListAndColor];
    NSArray *typeArray=[typeAndColorDict allKeys];
    if ([typeArray containsObject:type]) {
        UIColor *color=[UIColor colorRGBFromArray:[typeAndColorDict objectForKey:type]];
        return  color;
    }
    else
    {
        return nil;
    }
}

- (void)setIconBackgroundColor:(UIColor*)color
{
    if(color==nil) _typeView.backgroundColor=GreenFillColor;
    else _typeView.backgroundColor=color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
