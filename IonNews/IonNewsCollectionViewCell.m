//
//  IonNewsCollectionViewCell.m
//  IonNews
//
//  Created by Himanshu Rajput on 06/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonNewsCollectionViewCell.h"

@implementation IonNewsCollectionViewCell


-(void)setGradientView:(UIView *)gradientView{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2+30);
    
    //    gradient.colors = [NSArray arrayWithObjects:
    //                       (id)[[UIColor clearColor] CGColor],
    //                       [(id)[UIColor colorWithRed:126.0/255.0 green:0 blue:0 alpha:1.0] CGColor], nil];
    
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor clearColor] CGColor],
                       [(id)[UIColor blackColor] CGColor], nil];
    
    
    [gradientView.layer insertSublayer:gradient atIndex:2];
}

-(void)addPanGesture{
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] init];
    [panGesture addTarget:self action:@selector(handlePanGesture:)];
    panGesture.delaysTouchesBegan = false;
    panGesture.delaysTouchesEnded = false;
    panGesture.cancelsTouchesInView = true;
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}


-(void)handlePanGesture : (UIPanGestureRecognizer *)sender{
    
    [self bringSubviewToFront:sender.view];
    CGPoint translationPoint = [sender translationInView:sender.view.superview];
    CGPoint newCenter = CGPointMake(self.newsImageView.center.x, self.newsImageView.center.y + translationPoint.y/2);
    CGPoint velocity = [sender velocityInView:sender.view.superview];

    
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        
            if (self.newsImageView.center.y - self.center.y <= 75 && self.newsImageView.center.y >= self.center.y) {
                self.refreshLabel.text = @"Pull to refresh";
                [self.activityIndicator startAnimating];
                if (self.newsImageView.center.y - self.center.y >= 60) {
                    self.refreshLabel.text = @"Release to refresh";
                }
                self.newsImageView.center = newCenter;
                [sender setTranslation:CGPointZero inView:sender.view.superview];
                
            }

    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (self.newsImageView.center.y - self.center.y >= 75) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHomeScreen" object:nil];
        }
        [self.activityIndicator stopAnimating];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:10 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.newsImageView.center = CGPointMake(self.newsImageView.center.x, self.center.y);
        } completion:nil];
        
        
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    return fabs(velocity.y) > fabs(velocity.x);
}





@end
