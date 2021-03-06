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

#define DL_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define DL_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SafeAreaBottomHeight (DL_SCREEN_WIDTH / DL_SCREEN_HEIGHT < 0.5 ? 34 : 0)

@interface ViewController ()<DavidTextBarDelegate,DavidMediaViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic,strong)DavidTextBar *textBar;
@property(nonatomic,strong) DavidMediaView *mediaView;
@property(nonatomic,strong) DavidEmotionView *emotionView;
@property(nonatomic,assign) BOOL isSwitchingKeyboard;
@property(nonatomic,assign) CGRect keyBoardRect;
@property(nonatomic,assign) double duration;
@property(nonatomic,strong) UIImageView *pickedImageView;

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
        //_emotionView.backgroundColor = [UIColor blueColor];
    }
    return _emotionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textBar = [[DavidTextBar alloc] initWithFrame:CGRectMake(0, self.view.height - 44 - SafeAreaBottomHeight, self.view.width, 44)];
    self.textBar.delegate = self;
    [self.view addSubview:self.textBar];
    
    self.pickedImageView = [[UIImageView alloc] init];
    self.pickedImageView.frame = CGRectMake(60, 70, self.view.width -  120, self.view.width -  120);
    self.pickedImageView.contentMode = UIViewContentModeScaleAspectFit;
    //self.pickedImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.pickedImageView];
    
    
    //注册一个通知监听keyBoard位置的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //表情页面点击表情的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionPageDidSelect:) name:@"DavidEmotionPageViewDidSelectNotification" object:nil];
    //表情页面的删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDelete:) name:@"DavidEmotionPageViewDeleteNotification" object:nil];
    

    
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
    //self.textBar.textView.text = [NSString stringWithFormat:@"%@%@",self.textBar.textView.text,str];
    //插入表情
    [self.textBar.textView insertText:str];
}

-(void)emotionDelete:(NSNotification*)notification
{
    //删除文字的方法
    [self.textBar.textView deleteBackward];
}

- (void)messageViewAnimationWithMessageRect:(CGRect)rect  withMessageInputViewRect:(CGRect)inputViewRect andDuration:(double)duration andState:(InputViewStateType)state{
    
    [UIView animateWithDuration:duration animations:^{
        
        if (state == InputViewShowNone) {
            self.textBar.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect) -CGRectGetHeight(inputViewRect), CGRectGetWidth(self.view.frame),CGRectGetHeight(inputViewRect));
        } else {
            self.textBar.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect) -CGRectGetHeight(inputViewRect) - SafeAreaBottomHeight, CGRectGetWidth(self.view.frame),CGRectGetHeight(inputViewRect));
        }
        
        switch (state) {
            case InputViewShowNone:{
                self.mediaView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.mediaView.frame));
                
                self.emotionView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.emotionView.frame));
            }
                
                break;
                
            case InputViewShowAdd:{
                self.mediaView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect) - SafeAreaBottomHeight ,CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
                self.emotionView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.emotionView.frame));
            }
                
                break;
                
            case InputViewShowEmotion:{
                
                self.emotionView.frame = CGRectMake(0.0f,CGRectGetHeight(self.view.frame)-CGRectGetHeight(rect) - SafeAreaBottomHeight,CGRectGetWidth(self.view.frame),CGRectGetHeight(rect));
                
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
    [self messageViewAnimationWithMessageRect:CGRectMake(0, 0, 0, SafeAreaBottomHeight) withMessageInputViewRect:CGRectMake(0, 0, 0, 44) andDuration:0.25 andState:InputViewShowNone];
}

-(void)mediaView:(DavidMediaView *)mediaView didClickAtButton:(DavidMediaViewButtonType)button
{
    switch (button) {
        case DavidMediaViewPhotoButton:
            NSLog(@"DavidMediaViewPhotoButton");
            [self openAlbum];
            break;
          
        case DavidMediaViewCameraButton:
            NSLog(@"DavidMediaViewCameraButton");
            [self openCamera];
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

/** 打开相册 */
-(void)openAlbum
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

-(void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

/** 打开相册方法 */
-(void)openImagePickerController:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelgate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    self.pickedImageView.image = info[UIImagePickerControllerOriginalImage];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
