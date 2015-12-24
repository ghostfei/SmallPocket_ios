//
//  SquareListHeaderCell.m
//  SmallPocket
//
//  Created by ghostfei on 15/12/12.
//  Copyright © 2015年 ghostfei. All rights reserved.
//

#import "SquareListHeaderCell.h"
#import "Util.h"

@interface SquareListHeaderCell()<UIScrollViewDelegate>{
    NSInteger currentIndex;
    NSInteger PAGENUM;
}

@end

@implementation SquareListHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContent:(NSArray *)array{
    
    _myScrollView.contentSize = CGSizeMake(self.frame.size.width*array.count, 100);
    
    PAGENUM = array.count;
    _myScrollView.pagingEnabled=YES;
    _myScrollView.scrollEnabled=YES;
    _myScrollView.showsHorizontalScrollIndicator=NO;
    

    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, 100)];
        [imgview setImageWithURL:[NSURL URLWithString:[Util getAPIUrl:dic[@"image"]]] placeholderImage:[UIImage imageNamed:@""]];

        [_myScrollView addSubview:imgview];
    }
    
    
    //定义PageController 设定总页数，当前页，定义当控件被用户操作时,要触发的动作。
    _page.numberOfPages = PAGENUM;
    _page.currentPage = 0; 
    [_page addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    //使用NSTimer实现定时触发滚动控件滚动的动作。
    currentIndex = 0;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
}

#pragma mark 滚图的动画效果
-(void)pageTurn:(UIPageControl *)aPageControl{
    NSInteger whichPage = aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_myScrollView setContentOffset:CGPointMake(self.frame.size.width * whichPage, 0.0f) animated:YES];
    [UIView commitAnimations];
    _page.currentPage=whichPage;
}
#pragma page跟随scrollview滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    CGPoint offset=scrollView1.contentOffset;
    CGRect bounds=scrollView1.frame;
    [_page setCurrentPage:offset.x/bounds.size.width];
    currentIndex=_page.currentPage;
}
#pragma mark 定时滚动
-(void)scrollTimer{
    currentIndex ++;
    if (currentIndex == PAGENUM) {
        currentIndex = 0;
    }
    _page.currentPage=currentIndex;
    [_myScrollView scrollRectToVisible:CGRectMake(currentIndex * self.frame.size.width, 0, self.frame.size.width, 100) animated:YES];
}
@end
