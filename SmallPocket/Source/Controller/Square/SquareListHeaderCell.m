//
//  SquareListHeaderCell.m
//  SmallPocket
//
//  Created by ghostfei on 15/12/12.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SquareListHeaderCell.h"
#import "YJYYCollectionView.h"
#import "Util.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


#define kImageHeight 300

@interface SquareListHeaderCell()

@end

@implementation SquareListHeaderCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initScroll:(NSArray *)images{
    [YJYYCollectionView collectionViewWithFrame:CGRectMake(0, 44, kScreenWidth, kImageHeight) imageArray:images timeInterval:1.5 view:self];
}

@end
