//
//  SquareListCell.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SquareListCell.h" 
#import "Util.h"

@implementation SquareListCell

- (void)awakeFromNib {
    // Initialization code
    
    _bgView.layer.cornerRadius = 15;
    _bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContent:(Apps *)app{
    NSLog(@"app=%@",app);
    self.name.text = app.name;
    self.desc.text = app.desc;
    self.desc.font = [UIFont systemFontOfSize:14];
    
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%@",app.likenum] forState:UIControlStateNormal];
    [self.downBtn setTitle:[NSString stringWithFormat:@"%@",app.downnum] forState:UIControlStateNormal];
    
    NSString *iconurl = [Util getAPIUrl:app.icon];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 5;
    [self.icon setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if ([app.downstatus isEqual:@0]) {
        self.downBtn.enabled = YES;
        [self.downBtn setImage:[UIImage imageNamed:@"s_down"] forState:UIControlStateNormal];
    }else{
        self.downBtn.enabled = NO;
        [self.downBtn setImage:[UIImage imageNamed:@"s_down_ed"] forState:UIControlStateNormal];
    }
    
    if ([app.approvestatus isEqual:@1]) {
        self.zanBtn.enabled = NO;
        [self.zanBtn setImage:[UIImage imageNamed:@"s_like_ed"] forState:UIControlStateNormal];
    }else{
        self.zanBtn.enabled = YES;
        [self.zanBtn setImage:[UIImage imageNamed:@"s_like"] forState:UIControlStateNormal];
    }
}
@end
