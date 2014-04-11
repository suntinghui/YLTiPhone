//
//  UINavigationController+ios6.m
//  YLTiPhone
//
//  Created by 文彬 on 14-4-11.
//  Copyright (c) 2014年 xushuang. All rights reserved.
//

#import "UINavigationController+ios6.h"

@implementation UINavigationController (ios6)

-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end

