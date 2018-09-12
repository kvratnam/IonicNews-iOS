//
//  IonWebViewController.h
//  IonNews
//
//  Created by Himanshu Rajput on 13/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IonWebViewController : UIViewController

@property(nonatomic, strong)NSString *crawl_url;
@property(nonatomic,assign) int category_id;
@property (nonatomic,strong) NSString* content_id;
@property(nonatomic, assign) int islike;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@end
