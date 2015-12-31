//
//  DavidMediaView.h
//  KeyboradDemn
//
//  Created by DavidLee on 15/12/29.
//  Copyright © 2015年 DavidLee. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    DavidMediaViewPhotoButton,
    DavidMediaViewCameraButton,
    DavidMediaViewLocationButton,
    DavidMediaViewVideoButton,
    
}DavidMediaViewButtonType;

@class DavidMediaView;

@protocol DavidMediaViewDelegate <NSObject>

-(void)mediaView:(DavidMediaView*)mediaView didClickAtButton:(DavidMediaViewButtonType)button;

@end

@interface DavidMediaView : UIView

@property(nonatomic,assign)id<DavidMediaViewDelegate> delegate;


@end
