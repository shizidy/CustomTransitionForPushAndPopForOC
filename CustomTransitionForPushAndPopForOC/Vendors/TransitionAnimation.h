//
//  TransitionAnimation.h
//  CustomTransitionForPushAndPopForOC
//
//  Created by wdyzmx on 2020/8/11.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 定义转场类型枚举
typedef enum : NSUInteger {
    push,
    pop,
    present,
    dismiss,
} JumpType;

@interface TransitionAnimation : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>
/// 枚举
@property (nonatomic, assign) JumpType animationType;
/// 结束动画的动画
/// @param block 回调block
- (void)finishAnimation:(void (^)(void))block;
/// 取消动画的动画
/// @param block 回调block
- (void)cancelAnimation:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
