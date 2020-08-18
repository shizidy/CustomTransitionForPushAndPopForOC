//
//  TransitionAnimation.m
//  CustomTransitionForPushAndPopForOC
//
//  Created by wdyzmx on 2020/8/11.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "TransitionAnimation.h"
#import "Macro.h"
#import "BaseNavigationController.h"

@interface TransitionAnimation ()
@property (nonatomic, strong) UIViewController *fromVC;
@property (nonatomic, strong) UIViewController *toVC;
@property (nonatomic, strong, nullable) UIView *fromView;
@property (nonatomic, strong, nullable) UIView *toView;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BOOL isInteractive;
@property (nonatomic, assign) NSTimeInterval pausedTime;
@property (nonatomic, weak) id storedContext;
@end

@implementation TransitionAnimation

- (instancetype)init {
    if (self = [super init]) {
        self.timeInterval = 0.3;
        self.pausedTime = 0;
    }
    return self;
}

#pragma mark - UIViewControllerInteractiveTransitioning
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (self.fromVC == nil || self.toVC == nil) {
        return;
    }
    self.toView = self.toVC.view;
    self.fromView = self.fromVC.view;
    self.storedContext = transitionContext;
    [transitionContext.containerView insertSubview:self.toVC.view belowSubview:self.fromVC.view];
    self.toView.transform = CGAffineTransformMakeScale(DEFAULT_SCALE_X, DEFAULT_SCALE_Y);
}

#pragma mark - 重写父类方法updateInteractiveTransition
- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    if (self.storedContext == nil || self.fromView == nil || self.toView == nil) {
        return;
    }
    //
    self.fromView.frame = CGRectMake(kScreenWidth * percentComplete, 0, kScreenWidth, kScreenHeight);
    // 计算屏幕width,height对应的scaleX,scaleY
    CGFloat gapScale = (1 - DEFAULT_SCALE_X) * percentComplete;
    CGFloat scaleX = DEFAULT_SCALE_X + gapScale;
    CGFloat distance = (CGFloat)(kScreenWidth * (1 - scaleX));
    CGFloat scaleY = 1 - distance / kScreenHeight;
    self.toView.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    [self.storedContext updateInteractiveTransition:percentComplete];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.storedContext = transitionContext;
    switch (self.animationType) {
        case push:
        {
            [self pushAnimationWithTransitionContext:transitionContext];
        }
            break;
            
        default:
        {
            [self popAnimationWithTransitionContext:transitionContext];
        }
            break;
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.timeInterval;
}

#pragma mark - private method
- (void)pushAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC，fromVC就是转场前的VC
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([viewController isKindOfClass:[BaseNavigationController class]]) {
        BaseNavigationController *baseNav = (BaseNavigationController *)viewController;
        self.fromVC = baseNav.viewControllers.lastObject;
    } else {
        self.fromVC = viewController;
    }
    // 获取containerView
    UIView *containerView = transitionContext.containerView;
    [self.fromVC.tabBarController.tabBar setHidden:YES];
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:self.toVC.view];
    [containerView insertSubview:self.fromVC.view belowSubview:self.toVC.view];
    
    UIView *fromView = self.fromVC.view;
    UIView *toView = self.toVC.view;
    fromView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    toView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    
    [UIView animateWithDuration:self.timeInterval animations:^{
        fromView.transform = CGAffineTransformMakeScale(DEFAULT_SCALE_X, DEFAULT_SCALE_Y);
        toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        // 还原transform
        fromView.transform = CGAffineTransformIdentity;
    }];
}

- (void)popAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 通过viewControllerForKey取出转场前后的两个控制器，这里toVC就是转场后的VC，fromVC就是转场前的VC
    UIViewController *viewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([viewController isKindOfClass:[BaseNavigationController class]]) {
        BaseNavigationController *baseNav = (BaseNavigationController *)viewController;
        self.fromVC = baseNav.viewControllers.lastObject;
    } else {
        self.fromVC = viewController;
    }
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [self.toVC.tabBarController.tabBar setHidden:YES];
    
    // 引入containerView
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:self.toVC.view belowSubview:self.fromVC.view];
    
    UIView *fromView = self.fromVC.view;
    UIView *toView = self.toVC.view;
    fromView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    toView.transform = CGAffineTransformMakeScale(DEFAULT_SCALE_X, DEFAULT_SCALE_Y);
    
    [UIView animateWithDuration:self.timeInterval animations:^{
        toView.transform = CGAffineTransformIdentity;
        fromView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)finishAnimation:(void (^)(void))block {
    if (self.toView == nil || self.fromView == nil) {
        block();
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.fromView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight);
        self.toView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self.storedContext finishInteractiveTransition];
        [self.storedContext completeTransition:YES];
        self.storedContext = nil;
        self.toView = nil;
        self.fromView = nil;
        block();
    }];
}

- (void)cancelAnimation:(void (^)(void))block {
    if (self.toView == nil || self.fromView == nil) {
        block();
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.fromView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.toView.transform = CGAffineTransformMakeScale(DEFAULT_SCALE_X, DEFAULT_SCALE_Y);
    } completion:^(BOOL finished) {
        [self.storedContext finishInteractiveTransition];
        [self.storedContext completeTransition:NO];
        self.storedContext = nil;
        self.toView = nil;
        self.fromView = nil;
        self.toVC.view.transform = CGAffineTransformIdentity;
        block();
    }];
}


@end
