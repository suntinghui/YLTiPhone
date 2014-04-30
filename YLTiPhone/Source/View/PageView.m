//
//  PageView.m
//  POS2iPhone
//
//  Created by jia liao on 1/16/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "PageView.h"
//上页下页首页末页控件
@implementation PageView
@synthesize pageCountLabel = _pageCountLabel;
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *pageIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [pageIV setImage:[UIImage imageNamed:@"pagebg.png"]];
        [self addSubview:pageIV];
        
//        UIButton *firstPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [firstPageButton setFrame:CGRectMake(20, 7, 30, 20)];
//        [firstPageButton setBackgroundImage:[UIImage imageNamed:@"firstpage.png"] forState:UIControlStateNormal];
//        [firstPageButton addTarget:self action:@selector(firstPageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [firstPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [firstPageButton setTitle:@"首页" forState:UIControlStateNormal];
//        firstPageButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [self addSubview:firstPageButton];
        
        UIButton *previousPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [previousPageButton setFrame:CGRectMake(30, 7, 50, 20)];
        [previousPageButton setBackgroundImage:[UIImage imageNamed:@"previouspage.png"] forState:UIControlStateNormal];
        [previousPageButton addTarget:self action:@selector(previousPageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [previousPageButton setTitle:@"上一页" forState:UIControlStateNormal];
         [previousPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        previousPageButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:previousPageButton];
        
        self.pageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 30)];
        [self.pageCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.pageCountLabel setBackgroundColor:[UIColor clearColor]];
        [self.pageCountLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.pageCountLabel setText:@"第1/1页"];
        [self addSubview:self.pageCountLabel];
        
        UIButton *nextPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextPageButton setFrame:CGRectMake(235, 7, 50, 20)];
        [nextPageButton setBackgroundImage:[UIImage imageNamed:@"nextpage.png"] forState:UIControlStateNormal];
        [nextPageButton addTarget:self action:@selector(nextPageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [nextPageButton setTitle:@"下一页" forState:UIControlStateNormal];
        nextPageButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:nextPageButton];
        
//        UIButton *lastPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [lastPageButton setFrame:CGRectMake(285, 7, 30, 20)];
//        [lastPageButton setBackgroundImage:[UIImage imageNamed:@"lastpage.png"] forState:UIControlStateNormal];
//        [lastPageButton setTitle:@"末页" forState:UIControlStateNormal];
//        lastPageButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [previousPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [lastPageButton addTarget:self action:@selector(lastPageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:lastPageButton];
        
    }
    return self;
}

-(IBAction)firstPageButtonAction:(id)sender
{
    [self.delegate firstPageButtonAction];
}

-(IBAction)previousPageButtonAction:(id)sender
{
    [self.delegate previousPageButtonAction];
}

-(IBAction)nextPageButtonAction:(id)sender
{
   [self.delegate nextPageButtonAction];
}

-(IBAction)lastPageButtonAction:(id)sender
{
    [self.delegate lastPageButtonAction];
}

-(void)setNumerator:(NSString*)numerator denominator:(NSString*)denominator
{
    [self.pageCountLabel setText:[NSString stringWithFormat:@"第%@/%@页", numerator, denominator]];
}
@end
