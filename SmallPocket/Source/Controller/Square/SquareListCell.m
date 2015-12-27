//
//  SquareListCell.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SquareListCell.h"
#import "AppsModel.h"
#import "Util.h"

@implementation SquareListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContent:(NSDictionary *)dic{
    self.name.text = dic[@"name"];
    CGRect frame = self.desc.frame;
    self.desc.text = dic[@"desc"];
    CGSize size = CGSizeMake(self.frame.size.width-80, 1000);
    CGSize infoSize = [dic[@"desc"] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.desc.frame = CGRectMake(frame.origin.x, frame.origin.y, infoSize.width, infoSize.height);
    
    [self.zanBtn setTitle:dic[@"likenum"] forState:UIControlStateNormal];
    [self.downBtn setTitle:dic[@"downnum"] forState:UIControlStateNormal];
    
    NSString *iconurl = [Util getAPIUrl:dic[@"icon"]];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 5;
    [self.icon setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:[UIImage imageNamed:@"default_app"]];
    
    if ([dic[@"downstatus"] intValue]==0) {
        self.downBtn.enabled = YES;
        [self.downBtn setImage:[UIImage imageNamed:@"s_down"] forState:UIControlStateNormal];
    }else{
        self.downBtn.enabled = NO;
        [self.downBtn setImage:[UIImage imageNamed:@"s_down_ed"] forState:UIControlStateNormal];
    }
    
    if ([dic[@"approvestatus"] intValue]==1) {
        self.zanBtn.enabled = NO;
        [self.zanBtn setImage:[UIImage imageNamed:@"s_like_ed"] forState:UIControlStateNormal];
    }else{
        self.zanBtn.enabled = YES;
        [self.zanBtn setImage:[UIImage imageNamed:@"s_like"] forState:UIControlStateNormal];
    }
}
@end
