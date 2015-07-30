//
//  ConnectControl.m
//  TVFan
//
//  Created by apple on 12-12-4.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "ConnectControl.h"

@interface ConnectControl(){
    UIActivityIndicatorView * indicator;
    UILabel * loadingLabel;
    //UILabel * failLabel ;
    
    UIImageView *failImageView;
}

@end



@implementation ConnectControl

//@synthesize loading;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(ConnectControl *)showForView:(UIView *)view{
    
    CGRect frame = view.frame;
    frame.size.height = FirstPageHeight;
    
    ConnectControl *control = [[ConnectControl alloc]initWithFrame:frame];
    [view addSubview:control];
    
//    [control setLoading:YES];
//    
//    [control showLoadingIndicate];
    
    [control addTarget:control action:@selector(changeState:)  forControlEvents:UIControlEventTouchDown];
    
    return control ;
}


+(void)removeFromView:(UIView *)view{
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[ConnectControl class]]) {
			[v removeFromSuperview];
		}
	}
}


-(void)setLoading:(BOOL)loading{
    if (_loading!=loading) {
        _loading = loading;
        [self doChangeState];
    }
}


-(void)changeState:(id)sender{
    
    if(_loading==NO)
        [self setLoading:YES];
    
}


-(void)doChangeState{
    
    if (_loading==YES) {
        [self showLoadingIndicate];
        
        [self.delegate connect];
    }
    else{
        [self showFailIndicate];
    }
    
}
 

-(void)showLoadingIndicate{

    if (indicator==nil) {
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame =CGRectMake( (SCREENWIDTH-90)/2,(FirstPageHeight-20)/2,20, 20);
        [indicator startAnimating];
        [self addSubview:indicator];
        
    }

    
    if (loadingLabel==nil) {
        loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(indicator.frame.origin.x+indicator.frame.size.width+10,(FirstPageHeight-30)/2,70,30)];
        loadingLabel.textColor = [UIColor darkGrayColor];
        loadingLabel.text = @"正在加载";
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.font = [UIFont systemFontOfSize:15.0f];
        loadingLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:loadingLabel];
    }

    //failLabel.hidden=YES;
    failImageView.hidden = YES;
    indicator.hidden=NO;
    loadingLabel.hidden=NO;
}


-(void)showFailIndicate{
    
  /*  if (failLabel==nil) {
        failLabel = [[UILabel alloc]initWithFrame:CGRectMake( (SCREENWIDTH-150)/2,(FirstPageHeight-200)/2,150,200)];
        failLabel.textColor = [UIColor darkGrayColor];
        failLabel.numberOfLines=2;
        failLabel.text = @"网络好像有点问题\n点击屏幕重试";
        failLabel.textAlignment = NSTextAlignmentCenter;
        failLabel.font = [UIFont systemFontOfSize:14.0f];
        failLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:failLabel];
        [failLabel release];
    }

    failLabel.hidden=NO;*/
    
    if (failImageView==nil) {
        UIImage *image = [UIImage imageNamed:@"loadingFail.png"];
        failImageView = [[UIImageView alloc] initWithImage:image];
        failImageView.frame = CGRectMake( (SCREENWIDTH-image.size.width/2)/2, (FirstPageHeight-image.size.height/2)/2, image.size.width/2, image.size.height/2);
        [self addSubview:failImageView];
        
    }
    failImageView.hidden = NO;
    
    indicator.hidden=YES;
    loadingLabel.hidden=YES;
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
