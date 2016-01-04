//
//  DavidEmotionPageView.m
//  ChatKeyboardDemo
//
//  Created by DavidLee on 15/12/31.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "DavidEmotionPageView.h"
#import "UIView+Extension.h"
#import "NSString+Emoji.h"
#import "DavidEmotionDetailView.h"
#import "UIColor+randomColor.h"
@interface DavidEmotionPageView ()

@property(nonatomic,strong)DavidEmotionDetailView *detailView;
@property(nonatomic,strong) UIButton *deleteButton;

@end

@implementation DavidEmotionPageView

-(DavidEmotionDetailView*)detailView
{
    if (!_detailView) {
        self.detailView = [DavidEmotionDetailView detailView];
    }
    return _detailView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.deleteButton = [[UIButton alloc] init];
        [self.deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [self.deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [self.deleteButton  addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

-(void)setEmotionArray:(NSArray *)emotionArray
{
    _emotionArray = emotionArray;
    NSUInteger count = emotionArray.count;
    for (int i = 0 ; i < count; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        //button.backgroundColor = [UIColor randomColor];
        NSDictionary *emotionDic = emotionArray[i];
        NSString *emotionCode = emotionDic[@"code"];
        
        //emotion.code : 十六进制->表情
        [button setTitle:[NSString emojiWithStringCode:emotionCode] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        [button addTarget:self action:@selector(emotionButtonAction:)forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.emotionArray.count;
    
    CGFloat inset = 10;//内边距
    CGFloat btnWidth = (self.width - 2 * inset) / 7;
    CGFloat btnHeight = (self.height - 2 * inset) / 3;
    
    for (int i = 0 ; i < count; i++)
    {
        UIButton *button = (UIButton*)self.subviews[i];
        button.width = btnWidth;
        button.height = btnHeight;
        button.x = inset + (i%7) * btnWidth;
        button.y = inset + (i/7) * btnHeight;
        
    }
    
    self.deleteButton.width  = btnWidth;
    self.deleteButton.height = btnHeight;
    self.deleteButton.y = self.height - btnHeight - inset;
    self.deleteButton.x = self.width - inset - btnWidth;
    [self addSubview:self.deleteButton];
}

/** 按钮点击事件 */
-(void)emotionButtonAction:(UIButton*)button
{
   UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.detailView];
    
    //计算被点击的按钮在window中的frame
    CGRect buttonFrame =  [button convertRect:button.bounds toView:window];
    [self.detailView.detailButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    self.detailView.y = CGRectGetMidY(buttonFrame) - self.detailView.height;
    self.detailView.centerX = button.centerX;
    
    //延时之后移除detailView
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.30 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        [self.detailView removeFromSuperview];
    });
    
    //发出通知
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"selectedEmotion"] = button.titleLabel.text;
    NSNotification *notification =  [[NSNotification alloc] initWithName:@"DavidEmotionPageViewDidSelectNotification" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)deleteButtonAction:(UIButton*)button
{
    //删除按钮的通知
    NSNotification *notification = [[NSNotification alloc] initWithName:@"DavidEmotionPageViewDeleteNotification" object:nil userInfo: nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //也可以写成,同上。
    /*[[NSNotificationCenter defaultCenter] postNotificationName:@"DavidEmotionPageViewDeleteNotification" object:nil];*/
    
}



@end
