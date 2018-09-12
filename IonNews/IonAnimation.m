//
//  IonAnimation.m
//  IonNews
//
//  Created by Himanshu Rajput on 11/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonAnimation.h"

@implementation IonAnimation

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}
- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // TODO
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
      [[transitionContext containerView] addSubview:toVC.view];
    
    CGRect fullFrame = [transitionContext initialFrameForViewController:fromVC];
    CGFloat height = CGRectGetHeight(fullFrame);
    toVC.view.frame = CGRectMake(fullFrame.origin.x+20, height +16 +20, CGRectGetWidth(fullFrame)-40, height - 40);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.frame = CGRectMake(20, 20, CGRectGetWidth(fullFrame) - 40, height - 40);
        toVC.view.frame = CGRectMake(0, height/2, CGRectGetWidth(fullFrame), height/2);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    
}


@end
