//
//  RateForFit.h
//  SnapUpload
//
//  Created by fff on 16/1/4.
//  Copyright © 2016年 JellyKit Inc. All rights reserved.
//

#ifndef RateForFit_h
#define RateForFit_h

#define screenBounds [UIScreen mainScreen].bounds
#define screenWidth screenBounds.size.width
#define screenHeight screenBounds.size.height
#define rateOriginal sqrt((screenWidth*screenWidth+screenHeight*screenHeight)/(320*320+568*568))
#define rateToFit (rateOriginal >= 1 ? rateOriginal : 1)

#endif /* RateForFit_h */
