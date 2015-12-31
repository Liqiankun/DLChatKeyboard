//
//  DavidTextBar.h
//  KeyboradDemn
//
//  Created by DavidLee on 15/12/29.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DavidTextBarAddButton,
    DavidTextBarEmotionButton,
} DavidTextBarButtonType;


@class DavidTextBar;
@protocol DavidTextBarDelegate <NSObject>

-(void)textBar:(DavidTextBar*)textBar andButtonType:(DavidTextBarButtonType)buttonType andSelected:(BOOL)selected;
-(void)textbarTextViewDidBeginEnditing:(DavidTextBar*)texBar;

@end

@interface DavidTextBar : UIView

/** 添加多媒体button */
@property(nonatomic,strong) UIButton *addButton;
/** 表情button */
@property(nonatomic,strong) UIButton *emotionButton;

@property(nonatomic,assign) id<DavidTextBarDelegate> delegate;
/** 输入框 */
@property(nonatomic,strong)UITextView *textView;

-(void)setButtonsSelected:(BOOL)selected;

@end
