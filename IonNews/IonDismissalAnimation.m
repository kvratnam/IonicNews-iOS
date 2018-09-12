//
//  IonDismissalAnimation.m
//  IonNews
//
//  Created by Himanshu Rajput on 12/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonDismissalAnimation.h"

@implementation IonDismissalAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{

    return 1.0f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    
  __block  CGRect presentedFrame = [transitionContext initialFrameForViewController:fromVC];
    
    [UIView animateKeyframesWithDuration:0.5f delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
            toVC.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
            fromVC.view.frame = CGRectMake(presentedFrame.origin.x, [[UIScreen mainScreen] bounds].size.height/2, presentedFrame.size.width + 20, presentedFrame.size.height +20);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
            presentedFrame.origin.y += CGRectGetHeight(presentedFrame) + 20;
            toVC.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
            fromVC.view.frame = presentedFrame;
           // fromVC.view.transform = CGAffineTransformMakeRotation(0.2);
        }];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    

}


@end
