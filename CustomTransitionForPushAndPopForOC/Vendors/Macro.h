//
//  Macro.h
//  CustomTransitionForPushAndPopForOC
//
//  Created by wdyzmx on 2020/8/11.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height

#define DEFAULT_SCALE_X 0.95
#define DEFAULT_SCALE_Y 1 - (CGFloat)(kScreenWidth * (1 - DEFAULT_SCALE_X)) / kScreenHeight

#endif /* Macro_h */
