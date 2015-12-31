//
//  DavidMediaView.m
//  KeyboradDemn
//
//  Created by DavidLee on 15/12/29.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import "DavidMediaView.h"
#import "UIView+Extension.h"

@interface DavidMediaView()

/** 相册 */
@property(nonatomic,strong)UIButton *photoButton;
@property(nonatomic,strong) UIButton *cameraButton;
@property(nonatomic,strong) UIButton *locationButton;

@end

@implementation DavidMediaView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setButtonWithImage:@"photo_button" andButtonType:DavidMediaViewPhotoButton andName:@"照片"];
        [self setButtonWithImage:@"camera_button" andButtonType:DavidMediaViewCameraButton andName:@"拍照"];
        [self setButtonWithImage:@"location_button" andButtonType:DavidMediaViewLocationButton andName:@"位置"];
        [self setButtonWithImage:@"video_button" andButtonType:DavidMediaViewVideoButton andName:@"视频"];
        
    }
    return self;
}

-(void)setButtonWithImage:(NSString*)image andButtonType:(DavidMediaViewButtonType)buttonType andName:(NSString*)name
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:name forState:UIControlStateNormal];
//    button.layer.cornerRadius = 5;
//    button.layer.borderWidth = 0.5;
//    button.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.tag = buttonType;
    [self addSubview:button];
    

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidthHeight = 60;
    CGFloat disWidth = (self.width - 4 * buttonWidthHeight) / 5;
    CGFloat originY = (self.height - 2 * buttonWidthHeight) / 3;
    
    for (int i = 0; i < self.subviews.count; i ++) {
        UIButton *button = (UIButton*)self.subviews[i];
        button.x = buttonWidthHeight * i + (i + 1) * disWidth;
        button.y = originY;
        button.width = buttonWidthHeight;
        button.height = buttonWidthHeight;
  
        button.titleEdgeInsets = UIEdgeInsetsMake(40-15/2 + 8, -button.imageView.frame.size.width, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 15/2,15, -button.titleLabel.frame.size.width+15/2);

    }
    
}

-(void)buttonAction:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(mediaView:didClickAtButton:)]) {
        [self.delegate mediaView:self didClickAtButton:button.tag];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
