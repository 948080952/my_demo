//
//  DPTabBarItem.h
//  SnapUpload
//
//  Created by Dai Pei on 16/2/24.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPTabBarItem : UIControl
@property (nonatomic, strong)UIImage *selectImage;
@property (nonatomic, strong)UIImage *unSelectImage;
@property (nonatomic, assign)BOOL showLockImage;
@end
