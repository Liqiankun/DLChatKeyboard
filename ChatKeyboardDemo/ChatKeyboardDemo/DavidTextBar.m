//
//  DavidTextBar.m
//  KeyboradDemn
//
//  Created by DavidLee on 15/12/29.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "DavidTextBar.h"
#import "UIView+Extension.h"
#import "NSString+SIZEOFSTRING.h"
#import "DavidMediaView.h"



@interface DavidTextBar()<UITextViewDelegate>


/** 多媒体inputView */
@property(nonatomic,strong) DavidMediaView *mediaView;
@property(nonatomic,strong) UIButton *selectedButton;

@end

@implementation DavidTextBar


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化所有的空间
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor colorWithRed:0.83f green:0.83f blue:0.83f alpha:1.00f] CGColor];
        
        self.textView = [[UITextView alloc] init];
        self.textView.font = [UIFont systemFontOfSize:15];
        self.textView.textColor = [UIColor blackColor];
        self.textView.layer.cornerRadius = 5;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.borderColor = [[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] CGColor];
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.scrollEnabled = YES;
        self.textView.delegate = self;
      
        //设置没有文字时return键不能点击
        self.textView.enablesReturnKeyAutomatically = YES;
        [self addSubview:self.textView];
        
        
        self.addButton = [[UIButton alloc] init];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"add_button_selected"] forState:UIControlStateSelected];
        self.addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.addButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.addButton.tag = DavidTextBarAddButton;
        [self addSubview:self.addButton];
        
        self.emotionButton = [[UIButton alloc] init];
        [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"emotion_button"] forState:UIControlStateNormal];
        [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateSelected];
        self.emotionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.emotionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.emotionButton.tag = DavidTextBarEmotionButton;
        [self addSubview:self.emotionButton];
        
      
        
    
    }
    
    return self;
}


#pragma mark -- layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //在layoutSubviews里设置位置
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.height;
    CGFloat disWidth = 10;
    CGFloat btnWidthHeight = 30;
    CGFloat btnDisWidth = 10;
    CGFloat textViewWidth = selfWidth - 4 * btnDisWidth - 2 * btnWidthHeight;
    CGFloat textViewHeight = 30;
    
    
    self.textView.frame = CGRectMake(disWidth, 7, textViewWidth, textViewHeight);
    self.emotionButton.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) + btnDisWidth, selfHeight - 7 - btnWidthHeight , btnWidthHeight, btnWidthHeight);
    self.addButton.frame = CGRectMake(CGRectGetMaxX(self.emotionButton.frame) + btnDisWidth,  selfHeight - 7 - btnWidthHeight, btnWidthHeight, btnWidthHeight);
    
}


-(void)setButtonsSelected:(BOOL)selected
{
    self.addButton.selected = selected;
    self.emotionButton.selected = selected; 
}

#pragma mark -- UItextViewDelegate
/** 点击return键会调用 */
- (BOOL)textViewShouldReturn:(UITextView *)textView
{
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textbarTextViewDidBeginEnditing:)]) {
        [self.delegate textbarTextViewDidBeginEnditing:self];
    }
}


-(void)buttonAction:(UIButton*)button
{
   
    switch (button.tag) {
        case DavidTextBarAddButton:
        {
           
            self.emotionButton.selected = NO;
            
            button.selected = !button.selected;
            if (button.selected) {
                NSLog(@"表情被点击");
                [self.textView resignFirstResponder];
            }else{
               
                [self.textView becomeFirstResponder];
            }
            
            if ([self.delegate respondsToSelector:@selector(textBar:andButtonType:andSelected:)]) {
                [self.delegate textBar:self andButtonType:DavidTextBarAddButton andSelected:button.selected];
            }
        }
            
            break;
            
        case DavidTextBarEmotionButton:
        {
            self.addButton.selected = NO;
            
            button.selected = !button.selected;
            if (button.selected) {

                [self.textView resignFirstResponder];
            }else{
                
                [self.textView becomeFirstResponder];
            }
            
            if ([self.delegate respondsToSelector:@selector(textBar:andButtonType:andSelected:)]) {
                [self.delegate textBar:self andButtonType:DavidTextBarEmotionButton andSelected:button.selected];
            }

        }
            
            
            
            break;
            
        default:
            break;
    }
}


@end
