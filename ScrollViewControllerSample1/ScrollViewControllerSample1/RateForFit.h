//
//  RateForFit.h
//  emojiCollectionView
//
//  Created by Dai Pei on 16/2/17.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#ifndef RateForFit_h
#define RateForFit_h

#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height
#define rateOriginal sqrt((screenWidth*screenWidth + screenHeight*screenHeight) / (320*320 + 568*568))
#define rateToFit (rateOriginal >= 1 ? rateOriginal : 1)

#endif /* RateForFit_h */
