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
@implementation DavidEmotionPageView


-(void)setEmotionArray:(NSArray *)emotionArray
{
    _emotionArray = emotionArray;
    NSUInteger count = emotionArray.count;
    for (int i = 0 ; i < count; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        //button.backgroundColor = [DavidEmotionPageView randomColor];
        NSDictionary *emotionDic = emotionArray[i];
        NSString *emotionCode = emotionDic[@"code"];
        
        //emotion.code : 十六进制->表情
        [button setTitle:[NSString emojiWithStringCode:emotionCode] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        [self addSubview:button];
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.emotionArray.count;
    
    CGFloat inset = 10;//内边距
    CGFloat btnWidth = (self.width - 2 * inset) / 7;
    CGFloat btnHeight = (self.height - inset) / 3;
    
    for (int i = 0 ; i < count; i++)
    {
        UIButton *button = (UIButton*)self.subviews[i];
        button.width = btnWidth;
        button.height = btnHeight;
        button.x = inset + (i%7) * btnWidth;
        button.y = inset + (i/7) * btnHeight;
        
    }
}

/** 随机色 */
+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
