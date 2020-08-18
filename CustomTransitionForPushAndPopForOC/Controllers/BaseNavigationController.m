//
//  BaseNavigationController.m
//  CustomTransitionForPushAndPopForOC
//
//  Created by wdyzmx on 2020/8/11.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "BaseNavigationController.h"
#import "TransitionAnimation.h"
#import "Macro.h"

@interface BaseNavigationController () <UINavigationControllerDelegate>
/// 滑动进度
@property (nonatomic, assign) CGFloat percentComplete;
/// 区分是手势交互还是直接pop/push
@property (nonatomic, assign) BOOL isInteractive;
/// 添加标识，防止暴力操作
@property (nonatomic, assign) BOOL hold;
/// 自定义转场动画类transitionAnimation
@property (nonatomic, strong) TransitionAnimation *transitionAnimation;

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationBar setHidden:YES];
    self.delegate = self;
    
    [self addPanGestureAction];
    // Do any additional setup after loading the view.
}

#pragma mark - 拖动手势事件
- (void)pan:(UIPanGestureRecognizer *)pan {
    // 找到当前点
    CGPoint point = [pan translationInView:pan.view];
    self.percentComplete = fabs(point.x) / kScreenWidth;
    self.percentComplete = MIN(MAX(self.percentComplete, 0.01), 0.99);
    // 左滑不动时百分比 = 0
    if (point.x < 0) {
        self.percentComplete = 0;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.isInteractive = YES;
            if (self.viewControllers.count > 1) {
                [self popViewControllerAnimated:YES];
            }
        }
            break;
        
        case UIGestureRecognizerStateChanged:
        {
            [self.transitionAnimation updateInteractiveTransition:self.percentComplete];
        }
        break;
        
        case UIGestureRecognizerStateEnded:
        {
            self.isInteractive = NO;
            pan.enabled = NO;
            if (self.percentComplete >= 0.5) {
                [self.transitionAnimation finishAnimation:^{
                    pan.enabled = YES;
                }];
            } else {
                [self.transitionAnimation cancelAnimation:^{
                    pan.enabled = YES;
                }];
            }
        }
        break;
            
        case UIGestureRecognizerStateCancelled:
        {
            self.isInteractive = NO;
            pan.enabled = NO;
            if (self.percentComplete >= 0.5) {
                [self.transitionAnimation finishAnimation:^{
                    pan.enabled = YES;
                }];
            } else {
                [self.transitionAnimation cancelAnimation:^{
                    pan.enabled = YES;
                }];
            }
        }
        break;
            
        default:
            break;
    }
}

#pragma mark - private method
- (void)addPanGestureAction {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panGesture];
}

#pragma mark - 重写系统方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        self.transitionAnimation.animationType = push;
    } else if (operation == UINavigationControllerOperationPop) {
        self.transitionAnimation.animationType = pop;
    }
    return self.transitionAnimation;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (self.transitionAnimation.animationType == pop) {
        return self.isInteractive == YES ? self.transitionAnimation : nil;
    }
    return nil;
}

#pragma mark - 懒加载
- (TransitionAnimation *)transitionAnimation {
    if (!_transitionAnimation) {
        _transitionAnimation = [[TransitionAnimation alloc] init];
    }
    return _transitionAnimation;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
