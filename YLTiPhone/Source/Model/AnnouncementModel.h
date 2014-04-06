//
//  InsertAnnouncementModel.h
//  POS2iPhone
//
//  Created by  STH on 1/11/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnouncementModel : NSObject
{
    NSString        *_tel;              //手机号
    NSString        *_branch_id;        //机构编号
    NSString        *_notice_title;     //公告标题
    
    NSString        *_notice_content;   //公告内容
    NSString        *_notice_time;      //时间
    NSString        *_notice_date;      //日期
    
    NSString        *_notice_status;    //状态
    NSString        *_notice_type;
}

@property (nonatomic, strong) NSString      *tel;
@property (nonatomic, strong) NSString      *branch_id;
@property (nonatomic, strong) NSString      *notice_title;
@property (nonatomic, strong) NSString      *notice_content;

@property (nonatomic, strong) NSString      *notice_time;
@property (nonatomic, strong) NSString      *notice_date;
@property (nonatomic, strong) NSString      *notice_status;
@property (nonatomic, strong) NSString      *notice_type;

- (AnnouncementModel *) initWithDic:(NSDictionary *) dic;

@end