//
//  InsertAnnouncementModel.m
//  POS2iPhone
//
//  Created by  STH on 1/11/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "AnnouncementModel.h"

@implementation AnnouncementModel

@synthesize tel = _tel;
@synthesize branch_id = _branch_id;
@synthesize notice_content = _notice_content;
@synthesize notice_date = _notice_date;

@synthesize notice_status = _notice_status;
@synthesize notice_time = _notice_time;
@synthesize notice_title = _notice_title;
@synthesize notice_type = _notice_type;

- (id)init
{
    if (self = [super init]) {
        self.tel = @"";
        self.branch_id = @"" ;
        self.notice_title = @"";
        self.notice_content = @"";
        self.notice_date = @"";
        self.notice_status = @"";
        self.notice_time = @"";
        self.notice_type = @"";
    }
    
    return self;
}

- (AnnouncementModel *) initWithDic:(NSDictionary *) dic
{
    if (self = [super init]) {
        if ([[dic allKeys] containsObject:@"branch_id"]) {
            self.branch_id = [dic objectForKey:@"branch_id"];
        }
        if ([[dic allKeys] containsObject:@"notice_title"]) {
            self.notice_title = [dic objectForKey:@"notice_title"];
        }
        if ([[dic allKeys] containsObject:@"notice_content"]) {
            self.notice_content = [dic objectForKey:@"notice_content"];
        }
    }
    return self;
}

@end
