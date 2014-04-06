//
//  AnnouncementCell.m
//  POS2iPhone
//
//  Created by xushuang on 13-1-30.
//  Copyright (c) 2013年 RYX. All rights reserved.
//

#import "AnnouncementCell.h"

@implementation AnnouncementCell

@synthesize dateLabel;
@synthesize titleLabel;
@synthesize contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //标题
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 310, 25)];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        titleLabel.backgroundColor = [UIColor clearColor];
        //日期
        dateLabel = [[UILabel alloc] init];
        dateLabel.backgroundColor = [UIColor clearColor];
        [dateLabel setTextAlignment:NSTextAlignmentRight];
        [dateLabel setFont:[UIFont systemFontOfSize:15]];
        //内容
//        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.frame.size.width - 20, self.frame.size.height)];
        contentLabel = [[UILabel alloc] init];
        contentLabel.backgroundColor = [UIColor clearColor];
        [contentLabel setFont:[UIFont systemFontOfSize:15]];
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.numberOfLines = 0;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

@end
