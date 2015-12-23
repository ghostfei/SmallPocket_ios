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
    
    AppsModel *apps = [[AppsModel alloc]initWithDictionary:dic error:nil];
    self.name.text = apps.name;
    CGRect frame = self.desc.frame;
    self.desc.text = apps.desc;
    CGSize size = CGSizeMake(self.frame.size.width-80, 1000);
    CGSize infoSize = [apps.desc sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.desc.frame = CGRectMake(frame.origin.x, frame.origin.y, infoSize.width, infoSize.height);
    
    [self.zanBtn setTitle:apps.likenum forState:UIControlStateNormal];
    [self.downBtn setTitle:apps.downnum forState:UIControlStateNormal];
    
    NSString *iconurl = [Util getAPIUrl:apps.icon];
    [self.icon setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:[UIImage imageNamed:@"default_app"]];
    
    if ([apps.downstatus intValue]==0) {
        [self.downBtn setImage:[UIImage imageNamed:@"s_down"] forState:UIControlStateNormal];
    }else{
        self.downBtn.enabled = NO;
        [self.downBtn setImage:[UIImage imageNamed:@"s_down_ed"] forState:UIControlStateNormal];
    }
    
    if ([apps.approvestatus intValue]==1) {
        self.zanBtn.enabled = NO;
        [self.zanBtn setImage:[UIImage imageNamed:@"s_like_ed"] forState:UIControlStateNormal];
    }else{
        [self.zanBtn setImage:[UIImage imageNamed:@"s_like"] forState:UIControlStateNormal];
    }
}
@end
