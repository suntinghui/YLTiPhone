//
//  ShowFileContentViewController.h
//  LKOA4iPhone
//
//  Created by  STH on 7/31/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"

@interface ShowContentViewController : AbstractViewController <UIWebViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView   *webView;
@property (nonatomic, strong) UIActivityIndicatorView *progressInd;

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *htmlStr;

-(id) initWithFileName:(NSString *) fileName;
-(id) initWithUrl:(NSString *) url;
-(id) initWithHtmlString:(NSString *) htmlStr;

@end
