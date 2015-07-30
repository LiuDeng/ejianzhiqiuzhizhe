//
//  ChatListTableViewCell.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/29.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "UIImageView+EMWebCache.h"

@interface ChatListTableViewCell ()
{
    UILabel *_unreadLabel;
}

@end

@implementation ChatListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 20, 20)];
    _unreadLabel.backgroundColor = [UIColor redColor];
    _unreadLabel.textColor = [UIColor whiteColor];
    
    _unreadLabel.textAlignment = NSTextAlignmentCenter;
    _unreadLabel.font = [UIFont systemFontOfSize:11];
    _unreadLabel.layer.cornerRadius = 10;
    _unreadLabel.clipsToBounds = YES;
    [_backView addSubview:_unreadLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

- (void)setContentCell
{
    [self.logoImageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
    
    self.nameLabel.text = _name;
    
    _contentLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [_backView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
}

@end
