//
//  ScrollPageView.m
//  TVFan
//
//  Created by apple on 12-11-28.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "ScrollPageView.h"

#import "AppDelegate.h"

#define TURN_PAGE_TIME 3.0f

@interface ScrollPageView(){
    CGRect _frame;
}


@end


@implementation ScrollPageView

@synthesize scroll;
@synthesize pageControl,pages;

- (id)initWithFrame:(CGRect)frame views:(NSArray *)views infos:(NSArray *)infos
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _frame=frame;
        self.backgroundColor=[UIColor clearColor];
        
        //pages=images.count;
        pages=views.count;
        
    
//        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,_frame.size.width, _frame.size.height)];
//        scroll.pagingEnabled = YES;
//        scroll.showsHorizontalScrollIndicator = NO;
//        scroll.delegate = self;
//        scroll.bounces = YES;
//   
//        scroll.contentSize = CGSizeMake(_frame.size.width*pages, _frame.size.height);
//        scroll.backgroundColor= [UIColor clearColor];
//        [scroll.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
//
//        [self addSubview:scroll];
        //创建主滚动视图
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,_frame.size.width, _frame.size.height)];
        scroll.delegate = self;
        scroll.pagingEnabled = YES;
        scroll.userInteractionEnabled = YES;
        scroll.backgroundColor= [UIColor clearColor];
        scroll.bounces = YES;
        scroll.contentSize = CGSizeMake(_frame.size.width*pages, _frame.size.height);
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [scroll.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
        [self addSubview:scroll];
       
        for (int i=0;i<pages;i++) {
           UIView *view = (UIView *)[views objectAtIndex:i];
           view.frame=CGRectMake(_frame.size.width*i, 0, _frame.size.width, _frame.size.height);
            
          //  UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(_frame.size.width*i, 0, _frame.size.width, /_frame.size.height)];
         //   [button setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
            
           // //NSLog(@"%@",NSStringFromCGRect(view.frame));
            [scroll addSubview:view];
        }
        
        UIImageView *noteView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30,self.bounds.size.width,30)];
        [noteView setImage:[UIImage imageNamed:@"首页推荐-banner_bg640"]];
        
        //        float pageControlWidth=pages*10.0f+50.f;
        //        float pagecontrolHeight=6.0f;
        //        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),6, pageControlWidth, pagecontrolHeight)];
        //        pageControl.currentPage=0;
        //        pageControl.numberOfPages=pages;
        pageControl=[[SMPageControl alloc]initWithFrame:CGRectMake(0,19, SCREENWIDTH, 20)];
        pageControl.currentPage=0;
        pageControl.numberOfPages=pages;
        pageControl.alignment=SMPageControlAlignmentRight;
        pageControl.indicatorMargin = 4.0f;
        pageControl.indicatorDiameter = 4.0f;
        [noteView addSubview:pageControl];
        
        self.infos=infos;
        _infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, SCREENWIDTH, 20)];
        for (int i=0; i<infos.count; i++)
        {
            [_infoLabel setText:[infos objectAtIndex:i]];
        }
        [_infoLabel setTextColor:[UIColor whiteColor]];
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setFont:[UIFont systemFontOfSize:13]];
        [noteView addSubview:_infoLabel];
        [self addSubview:noteView];

        
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,_frame.size.height-30, 320, 30)];
////        imageView.image = [UIImage imageNamed:@"pageControlBG"];
//        //新年首页推荐 jxy --1.23
//        imageView.image = [UIImage imageNamed:@"banner_title_bg.png"];
//        [self addSubview:imageView];
       
        
        
//        self.infos=infos;
//        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,_frame.size.height-30, 220, 30)];
//        _infoLabel.textColor = [UIColor darkGrayColor];
//		_infoLabel.textAlignment = NSTextAlignmentLeft;
//		_infoLabel.font = [UIFont boldSystemFontOfSize:13.0f];
//        
//        if(infos.count>0)
//            _infoLabel.text = [infos objectAtIndex:0];
//        
//		_infoLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:_infoLabel];
//
//        
//        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(220,_frame.size.height-30, 100, 30)];
//        pageControl.numberOfPages = pages;
//        pageControl.currentPage = 0;
//        pageControl.enabled=NO;
//        pageControl.pageIndicatorTintColor = [UIColor grayColor];
//        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
//        pageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//        [self  addSubview:pageControl];
    
        
        
        [self performSelector:@selector(autoTurnPage) withObject:nil afterDelay:TURN_PAGE_TIME];
    }
    return self;
}

-(void)updateWithViews:(NSArray *)views{
    for(UIView *view in scroll.subviews){
        [view removeFromSuperview];
    }
    
    pages=views.count;
    
    for (int i=0;i<pages;i++)
    {
        UIView *view = (UIView *)[views objectAtIndex:i];
        view.frame=CGRectMake(_frame.size.width*i, 0, _frame.size.width, _frame.size.height);
        [scroll addSubview:view];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    if (self.infos.count>page)
    {
        NSString *info = [self.infos objectAtIndex:page];
        _infoLabel.text = info;
    }
   
    [self manDidTurnPage];

}

#pragma mark 主视图逻辑方法


//传递滑动事件给下一层
-(void)scrollHandlePan:(UIPanGestureRecognizer*) panParam
{
//    //当滑道左边界时，传递滑动事件给代理
//     DSFAppDelegate *_appDelegate = (DSFAppDelegate *)[UIApplication sharedApplication].delegate;
//    if(scroll.contentOffset.x <= 0)
//    {
//        [_appDelegate.viewController _handlePan:panParam];
//
//    } else if(scroll.contentOffset.x >= scroll.contentSize.width - scroll.bounds.size.width)
//    {
//         [_appDelegate.viewController _handlePan:panParam];
//    }
}

#pragma mark turnPage
-(void)autoTurnPage{
    if (pageControl.currentPage+1<pageControl.numberOfPages) {
        pageControl.currentPage=pageControl.currentPage+1;
    }else
        pageControl.currentPage=0;
    
    [self doTurnPage];
    
    //  [self performSelector:@selector(autoTurnPage) withObject:nil afterDelay:4.0f];
}


-(void)doTurnPage{
    NSInteger whichPage = pageControl.currentPage;
	
    _infoLabel.text = [self.infos objectAtIndex:whichPage];
    
    if (whichPage!=0) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        scroll.contentOffset = CGPointMake(320.0f * whichPage,0.0f);
        [UIView commitAnimations];
    }
    else {
        [scroll setContentOffset:CGPointMake(0,0) animated:NO];
    }
   
    
}


-(void)manDidTurnPage{
    [ScrollPageView cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoTurnPage) object:nil];
    [self performSelector:@selector(autoTurnPage) withObject:nil afterDelay:TURN_PAGE_TIME];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
