//
//  MLMapView.m
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLMapView.h"
#import "CustomAnnotationView.h"
#import "AJLocationManager.h"
#import "UIView+ImageFromView.h"
@implementation MLMapView
@synthesize mapView=_mapView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_mapView];
        _mapView.userInteractionEnabled=YES;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        [_mapView setZoomLevel:10.0f];

        pointAnnoArray=[[NSMutableArray alloc]init];
        firstLoad=YES;
        requestUserLocation=NO;
    }
    return self;
}


/**
 *  添加单个Annotation到地图上
 *
 *  @param point    点做坐标
 *  @param title    显示的内容
 *  @param index    对应tableView 的tag
 *  @param isCenter 是否设置该点坐标为地图中心
 */
- (void)addAnnotation:(CLLocationCoordinate2D)point Title:(NSString*)title  Subtitle:(NSString*)subtitle Index:(NSInteger)index SetToCenter:(BOOL)isCenter{
    
    MAPointAnnotation *sellerPoint = [[MAPointAnnotation alloc] init];
    btnIndex=index;
    
    [pointAnnoArray addObject:sellerPoint];
    sellerPoint.coordinate = point;
    sellerPoint.title=title;
    sellerPoint.subtitle=subtitle;
    [_mapView addAnnotation:sellerPoint];
    if (isCenter) {
        _mapView.region = MACoordinateRegionMake(point,MACoordinateSpanMake(0.005, 0.005));
    }else{
        //        _mapView.showsUserLocation=YES;
    }
    if(index==NSIntegerMax) {self.userAddMAPointAnnotation=sellerPoint;
        [_mapView selectAnnotation:sellerPoint animated:YES];
    }
}

/**
 *  高德的回调函数
 *
 *  @param mapView    <#mapView description#>
 *  @param annotation <#annotation description#>
 *
 *  @return <#return value description#>
 *
 *  高德能否保证连续对应的回调该函数。button 对应的Index 不好控制
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
//        annotationView.rightCalloutAccessoryView=nil;
        annotationView.image=[UIImage imageNamed:@"greenPin.png"];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }else{
            
            annotationView.rightCalloutAccessoryView=nil;
            annotationView.image=nil;
        }
        
        if (btnIndex==NSIntegerMax)
        {
            annotationView.image = [UIImage imageNamed:@"redPin"];
            
            // 设置为NO，用以调用自定义的calloutView
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(0, 0);
        }
        else if(NSIntegerMin==btnIndex){
            
            annotationView.image = [UIImage imageNamed:@"purplePin"];
            
            // 设置为NO，用以调用自定义的calloutView
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(0, 0);
        }
        
        else{
//            UIImage *image=[UIView createImageFromView:annotationView];
//            annotationView.image=image;
            annotationView.image=[UIImage imageNamed:@"greenPin.png"];
            // 设置为NO，用以调用自定义的calloutView
            annotationView.canShowCallout = YES;
            // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
            annotationView.centerOffset = CGPointMake(0, -18);
            //设置点击事件
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            //设置所选annotion Index,利用tag;
            btn.tag=btnIndex;
            [btn setImage:[UIImage imageNamed:@"mapDetail"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView=btn;
        }
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        annotationView.rightCalloutAccessoryView=nil;
        annotationView.image = [UIImage imageNamed:@"annotation.png"];
    }
    return nil;
}


- (void)showDetails:(id)sender{
    UIButton *button = (UIButton *)sender;
    [self.showDetailDelegate showDetail:button.tag];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
//        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"userPosition"];
        pre.lineWidth = 3;
        //        pre.lineDashPattern = @[@6, @3];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
    }  
}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
    if (requestUserLocation) {
        //更新用户信息
        AJLocationManager *locationManger=[AJLocationManager shareLocation];
        locationManger.lastCoordinate=userLocation.coordinate;
        [locationManger getReverseGeocode];
        
        _mapView.region = MACoordinateRegionMake([_mapView userLocation].coordinate,MACoordinateSpanMake(0.05, 0.05));
        _mapView.showsUserLocation=YES;
    }else if (firstLoad) {
        _mapView.region = MACoordinateRegionMake([_mapView userLocation].coordinate,MACoordinateSpanMake(0.05, 0.05));
        firstLoad=NO;
    }
}

-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    requestUserLocation=NO;
    _mapView.showsUserLocation=YES;
}

/**
 *  设置地图中心
 *
 *  @param point <#point description#>
 */
-(void)setCenterAtPoint:(CLLocationCoordinate2D)point
{
    _mapView.region = MACoordinateRegionMake(point,MACoordinateSpanMake(0.05, 0.05));
}

-(void)ShowCalloutView
{
    //注一次只能显示一个
    for (MAPointAnnotation *annotation in pointAnnoArray) {
        [_mapView selectAnnotation:annotation animated:YES];
    }
}



//主动请求定位
- (void)setShowUserLocation:(BOOL)isShow{
    requestUserLocation=YES;
    _mapView.showsUserLocation=isShow;
    //
}

- (void)removeAllAnnotations{
    [_mapView removeAnnotations:pointAnnoArray];
    [pointAnnoArray removeAllObjects];
}

@end

