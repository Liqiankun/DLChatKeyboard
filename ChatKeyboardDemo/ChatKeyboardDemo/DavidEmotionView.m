//
//  DavidEmotionView.m
//  KeyboradDemn
//
//  Created by DavidLee on 15/12/30.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "DavidEmotionView.h"
#import "UIView+Extension.h"
#import "DavidEmotionPageView.h"
#import "UIColor+randomColor.h"

@interface DavidEmotionView()<UIScrollViewDelegate>

/** 放置表情的scrollView */
@property(nonatomic,strong) UIScrollView *emotionScrollView;
/** 删除按钮 */
@property(nonatomic,strong) UIPageControl *pageControl;
/** 表情数据 */
@property(nonatomic,strong) NSArray *emotionArray;

@end

@implementation DavidEmotionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化所有控件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emotion.plist" ofType:nil];
        self.emotionArray = [[NSArray alloc] initWithContentsOfFile:path];
        NSLog(@"self.emotionArray----%lu",(unsigned long)self.emotionArray.count);
        
        self.emotionScrollView = [[UIScrollView alloc] init];
        self.emotionScrollView.pagingEnabled = YES;
        self.emotionScrollView.showsHorizontalScrollIndicator = NO;
        self.emotionScrollView.showsVerticalScrollIndicator = NO;
        self.emotionScrollView.delegate = self;
        [self addSubview:self.emotionScrollView];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.userInteractionEnabled = NO;
        
       /* self.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pageControl_image"]];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pageControl_image_selected"]];
        self.backgroundColor = [UIColor redColor];*/
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [self addSubview:self.pageControl];
        
        //向scrollView添加表情页数
        NSInteger emotionCount = self.emotionArray.count;
        self.pageControl.numberOfPages = (emotionCount + DavidEmotionPageSize -1) / DavidEmotionPageSize;
        
        for (int i = 0; i < self.pageControl.numberOfPages; i++) {
            DavidEmotionPageView *emotionView = [[DavidEmotionPageView alloc] init];
            //设置表情范围
            NSRange range;
            range.location = i * DavidEmotionPageSize;
            NSUInteger leftCount = self.emotionArray.count - range.location;
            if (leftCount >= DavidEmotionPageSize) {
                range.length = DavidEmotionPageSize;
            }else{
                range.length = leftCount;
            }
            NSLog(@"range.length-----%ld",range.length);
            
            emotionView.emotionArray = [self.emotionArray subarrayWithRange:range];
            [self.emotionScrollView addSubview:emotionView];
            //emotionView.backgroundColor = [UIColor randomColor];
        }
    
    }
    
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pageControl.height = 35;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - 35;
    self.pageControl.width = self.width;
    
    self.emotionScrollView.x = 0;
    self.emotionScrollView.y = 0;
    self.emotionScrollView.height = self.pageControl.y;
    self.emotionScrollView.width = self.width;
    self.emotionScrollView.bounces = NO;
    
    self.emotionScrollView.contentSize = CGSizeMake(self.width * self.pageControl.numberOfPages, 0);
    
    //设置self.emotionScrollView里的子控件的位置
    for (int i = 0; i < self.emotionScrollView.subviews.count; i++) {
        DavidEmotionPageView *emotionView = (DavidEmotionPageView*)self.emotionScrollView.subviews[i];
        emotionView.width = self.width;
        emotionView.height = self.emotionScrollView.height;
        emotionView.x = self.width * i;
        emotionView.y = 0;
    }
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNumber = scrollView.contentOffset.x/scrollView.width;
    self.pageControl.currentPage = (int)(pageNumber + 0.5);
}


@end



























