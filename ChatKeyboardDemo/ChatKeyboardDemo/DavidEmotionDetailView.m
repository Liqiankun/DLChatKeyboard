//
//  DavidEmotionDetailView.m
//  ChatKeyboardDemo
//
//  Created by DavidLee on 15/12/31.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "DavidEmotionDetailView.h"

@implementation DavidEmotionDetailView

+(instancetype)detailView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"DavidEmotionDetailView" owner:nil options:nil] lastObject];
}
@end
