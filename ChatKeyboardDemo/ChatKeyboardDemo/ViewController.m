//
//  ViewController.m
//  KeyboradDemn
//
//  Created by DavidLee on 15/12/29.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "ViewController.h"
#import "DavidTextBar.h"
#import "DavidMediaView.h"
#import "DavidEmotionView.h"
#import "UIView+Extension.h"
@interface ViewController ()<DavidTextBarDelegate,DavidMediaViewDelegate>

@property(nonatomic,strong)DavidTextBar *textBar;
@property(nonatomic,strong) DavidMediaView *mediaView;
@property(nonatomic,strong) DavidEmotionView *emotionView;
@property(nonatomic,assign) BOOL isSwitchingKeyboard;
@property(nonatomic,assign) CGRect keyBoardRect;
@property(nonatomic,assign) double duration;
@end

@implementation ViewController

-(DavidMediaView*)mediaView
{
    if (!_mediaView) {
        _mediaView  = [[DavidMediaView alloc] initWithFrame:CGRectMake(0, self.view.height,[UIScreen mainScreen].bounds.size.width, 220)];
        [self.view addSubview:_mediaView];
        _mediaView.delegate = self;
    }
    return _mediaView;
}

-(DavidEmotionView*)emotionView
{
    if (!_emotionView) {
        _emotionView  = [[DavidEmotionView alloc] initWithFrame:CGRectMake(0, self.view.height,[UIScreen mainScreen].bounds.size.width , 220)];
        [self.view addSubview:_emotionView];
        _emotionView.backgroundColor = [UIColor blueColor];
    }
    return _emotionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textBar = [[DavidTextBar alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    self.textBar.delegate = self;
    //[self.textBar.textView becomeFirstResponder];
    [self.view addSubview:self.textBar];
    
    
    //注册一个通知监听keyBoard位置的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionPageDidSelect:) name:@"DavidEmotionPageViewDidSelectNotification" object:nil];

}

-(void)textBar:(DavidTextBar *)textBar andButtonType:(DavidTextBarButtonType)buttonType andSelected:(BOOL)selected
{
    switch (buttonType) {
        case DavidTextBarEmotionButton:{
            [self changeEmotionViewFrame:selected];
        }
            
            break;
            
        case DavidTextBarAddButton:{
            [self changeAddViewFrame:selected];
        }
            
            break;
            
        default:
            
            break;
    }
}



-(void)keyBoardWillShow:(NSNotification*)notification
{
    NSDictionary *infoDic = notification.userInfo;
    //取出动画的时间
    self.duration = [infoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyBoardRect = [infoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

-(void)keyBoardWillHide:(NSNotification*)notification
{
    NSDictionary *infoDic = notification.userInfo;
    //取出动画的时间
    self.duration  = [infoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyBoardRect  = [infoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

-(void)keyBoardFrameDidChange:(NSNotification*)notification
{
    
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.view.frame)) {
        [self messageViewAnimationWithMessageRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:0.25
                                         andState:InputViewShowNone];
        
    }
    

}

-(void)emotionPageDidSelect:(NSNotification*)notification
{
    NSString *str = notification.userInfo[@"selectedEmotion"];
    self.textBar.textView.text = [NSString stringWithFormat:@"%@%@",self.textBar.textView.text,str];
}

- (void)messageViewAnimationWithMessageRect:(CGRect)rect  withMessageInputViewRect:(CGRect)inputViewRect andDuration:(double)duration andState:(InputViewStateType)state{
    
    [UIView animateWithDuration:duration animations:^{
        self.textBar.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect)-CGRectGetHeight(inputViewRect),CGRectGetWidth(self.view.frame),CGRectGetHeight(inputViewRect));
        
        switch (state) {
            case InputViewShowNone:{
                self.mediaView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.mediaView.frame));
                
                self.emotionView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.emotionView.frame));
            }
                
                break;
                
            case InputViewShowAdd:{
                self.mediaView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
                self.emotionView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.emotionView.frame));
            }
                
                break;
                
            case InputViewShowEmotion:{
                
                self.emotionView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect),CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
                self.mediaView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.mediaView.frame));
                
            }
                
                break;
                
            default:
                break;
        }
        
    }];

}

-(void)changeEmotionViewFrame:(BOOL)selected
{
    if (selected)
    {
        [self messageViewAnimationWithMessageRect:self.emotionView.frame
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:self.duration
                                         andState:InputViewShowEmotion];
    }else{
        [self messageViewAnimationWithMessageRect:self.keyBoardRect
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:self.duration
                                         andState:InputViewShowNone];
    }

}

-(void)changeAddViewFrame:(BOOL)selected
{
    if (selected)
    {
        [self messageViewAnimationWithMessageRect:self.mediaView.frame
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:self.duration
                                         andState:InputViewShowAdd];
    }else{
        [self messageViewAnimationWithMessageRect:self.keyBoardRect
                         withMessageInputViewRect:self.textBar.frame
                                      andDuration:self.duration
                                         andState:InputViewShowNone];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.textBar.emotionButton.selected = NO;
    self.textBar.addButton.selected = NO;
    [self messageViewAnimationWithMessageRect:CGRectMake(0, 0, 0, 0) withMessageInputViewRect:self.textBar.frame andDuration:0.25 andState:InputViewShowNone];
}

-(void)mediaView:(DavidMediaView *)mediaView didClickAtButton:(DavidMediaViewButtonType)button
{
    switch (button) {
        case DavidMediaViewPhotoButton:
            NSLog(@"DavidMediaViewPhotoButton");
            break;
          
        case DavidMediaViewCameraButton:
            NSLog(@"DavidMediaViewCameraButton");
            break;
            
        case DavidMediaViewLocationButton:
            NSLog(@"DavidMediaViewLocationButton");
            break;
            
        case DavidMediaViewVideoButton:
            NSLog(@"DavidMediaViewVideoButton");
            break;
            
        default:
            break;
    }
}

-(void)textbarTextViewDidBeginEnditing:(DavidTextBar *)texBar
{
    self.textBar.emotionButton.selected = NO;
    self.textBar.addButton.selected = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
