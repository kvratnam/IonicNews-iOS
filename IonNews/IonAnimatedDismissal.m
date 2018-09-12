//
//  IonAnimatedDismissal.m
//  IonNews
//
//  Created by Himanshu Rajput on 14/05/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonAnimatedDismissal.h"

@implementation IonAnimatedDismissal

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{

    return 1.0f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect initialFrame = fromVC.view.frame;
    CGRect finalFrame = CGRectMake(initialFrame.origin.x, initialFrame.size.height + 16, initialFrame.size.width, initialFrame.size.height);
    UIViewAnimationOptions opts = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:1.0 delay:0 options:opts animations:^{
        fromVC.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}



@end
