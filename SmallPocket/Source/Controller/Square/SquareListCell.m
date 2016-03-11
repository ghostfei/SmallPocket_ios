//
//  SquareListCell.m
//  SmallPocket
//
//  Created by ghostfei on 15/11/14.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SquareListCell.h" 
#import "Util.h"

@interface SquareListCell(){
    NSArray *_colorArray;
}
@end

@implementation SquareListCell

- (void)awakeFromNib {
    // Initialization code
    
    _bgView.layer.cornerRadius = 15;
    _bgView.layer.masksToBounds = YES;
    
    _colorArray = @[[UIColor blueColor],[UIColor purpleColor],[UIColor greenColor],[UIColor redColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContent:(Apps *)app{
//    NSLog(@"app=%@",app);
    for (UIView *vi in self.contentView.subviews) {
        if ([vi isKindOfClass:[UIButton class]] && vi.tag<1000) {
            [vi removeFromSuperview];
        }
    }
    
    self.name.text = app.name;
    self.desc.text = app.desc;
    self.desc.font = [UIFont systemFontOfSize:14];
    
    NSArray *tags = @[];
    if (app.tags.length>0) {
        tags = [app.tags componentsSeparatedByString:@"#"];
    } 
    NSLog(@"tags=%@",tags);
    if (tags.count>0) {
        [self addTags:tags];
    }
    
    [self.zanBtn setTitle:[NSString stringWithFormat:@" %@",app.likenum] forState:UIControlStateNormal];
    [self.downBtn setTitle:[NSString stringWithFormat:@" %@",app.downnum] forState:UIControlStateNormal];
    
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

-(void)addTags:(NSArray *)array{
    [array enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *tabBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.name.frame.size.width+self.name.frame.origin.x+1 + idx*25, 12, 24, 14)];
        [self.contentView addSubview:tabBtn];
        
        [tabBtn setTitle:tag forState:UIControlStateNormal];
        tabBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [tabBtn setTitleColor:_colorArray[idx+1] forState:UIControlStateNormal];
        if ([tag isEqualToString:@"官方"]) {
            [tabBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        
        tabBtn.layer.borderWidth = 0.5;
        tabBtn.layer.borderColor = tabBtn.titleLabel.textColor.CGColor;
    }];
}
@end
