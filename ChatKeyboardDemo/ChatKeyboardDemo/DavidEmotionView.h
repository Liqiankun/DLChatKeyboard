//
//  DavidEmotionView.h
//  KeyboradDemn
//
//  Created by DavidLee on 15/12/30.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import <UIKit/UIKit.h>

// 一页中最多3行
#define DavidEmotionMaxRows 3
// 一行中最多7列
#define DavidEmotionMaxCols 7
// 每一页的表情个数
#define DavidEmotionPageSize ((DavidEmotionMaxRows * DavidEmotionMaxCols) - 1)

@interface DavidEmotionView : UIView



@end
